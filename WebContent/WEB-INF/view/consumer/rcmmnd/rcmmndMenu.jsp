<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>트럭왔냠 - 추천 메뉴</title>
	<!-- 반응형 웹 설정 -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<style>
	
		html, body {
			padding: 0;
			margin: 0;
			box-sizing: border-box;
			font-family: Helvetica, Calibri, Roboto, Open Sans, sans-serif
			-webkit-backface-visibility: hidden;
		}
		* {
			box-sizing: inherit;
		}
		h1 {
			text-align: center;
		}
		svg {
			margin:auto;
			display:block;
		}

		.circle-overlay {
			font-size: 16px;
			border-radius: 50%;
			position: absolute;
			overflow: hidden;
			/*it's buggy with the foreignObject background right now*/
			/*background-color: rgba(255,255,255,0.5);*/
		}
		.circle-overlay__inner {
			text-align: center;
			width: 100%;
			height: 100%;
		}

		.hidden {
			display: none;
		}
		.node-icon--faded {
			opacity: 0.5;
		}
		.legend-size circle {
			fill: rgb(31, 119, 180);
		}
	</style>
</head>
<body>
	<h1>트럭 왔냠이 추천하는 메뉴</h1>
	<svg width="100%" height="700" font-family="sans-serif" font-size="10" text-anchor="middle"></svg>
	
	<script src="/resources/js/consumer/d3.min.js"></script>
	<script src="/resources/js/consumer/d3-legend.min.js"></script>
	<script>
		// Based loosely from this D3 bubble graph https://bl.ocks.org/mbostock/4063269
		// And this Forced directed diagram https://bl.ocks.org/mbostock/4062045
		let data = [{
			cat: 'library', name: '솜사탕맛아이스크림', value: 50,
			icon: '/resources/img/consumer/img/somsatang.jpg',
			desc: `
				D3.js (or just D3 for Data-Driven Documents) is a JavaScript library for
				producing dynamic, interactive data visualizations in web browsers.
				It makes use of the widely implemented SVG, HTML5, and CSS standards.<br>
				This infographic you are viewing is made with D3.
			`
			
		}, {
			cat: 'library', name: '라면라면', value: 100,
			icon: '/resources/img/consumer/img/201808061150.jpg',
			desc: `
				Raphaël is a cross-browser JavaScript library that draws Vector graphics for web sites.
				It will use SVG for most browsers, but will use VML for older versions of Internet Explorer.
			`
		}, {
			cat: 'library', name: 'Relay', value: 70,
			icon: '/resources/img/consumer/img/relay.svg',
			desc: `
				A JavaScript framework for building data-driven React applications.
				It uses GraphQL as the query language to exchange data between app and server efficiently.
				Queries live next to the views that rely on them, so you can easily reason
				about your app. Relay aggregates queries into efficient network requests to fetch only what you need.
			`
		}, {
			cat: 'library', name: 'Three.js', value: 100,
			icon: '/resources/img/consumer/img/201808061650.jpg',
			desc: `
				Three.js allows the creation of GPU-accelerated 3D animations using
				the JavaScript language as part of a website without relying on
				proprietary browser plugins. This is possible thanks to the advent of WebGL.
			`
		}, {
			cat: 'library', name: 'Lodash', value: 20,
			icon: '/resources/img/consumer/img/201808061650.jpg',
			desc: `
				Lodash is a JavaScript library which provides <strong>utility functions</strong> for
				common programming tasks using the functional programming paradigm.`
		}, {
			cat: 'library', name: 'Moment JS', value: 50,
			icon: '/resources/img/consumer/img/201808061450.jpg',
			desc: `
				Handy and resourceful JavaScript library to parse, validate, manipulate, and display dates and times.
			`
		
		}, {
			cat: 'library', name: 'abcd', value: 50,
			icon: '/resources/img/consumer/img/201808061650.jpg',
			desc: `
				Lodash is common programming tasks using the functional programming paradigm.`
		}];
	</script>

	<script>
		let svg = d3.select('svg');
		let width = document.body.clientWidth; // get width in pixels
		let height = +svg.attr('height');
		let centerX = width * 0.5;
		let centerY = height * 0.5;
		let strength = 0.05;
		let focusedNode;

		let format = d3.format(',d');

		let scaleColor = d3.scaleOrdinal(d3.schemeCategory20);

		// use pack to calculate radius of the circle
		let pack = d3.pack()
			.size([width , height ])
			.padding(1.5);

		let forceCollide = d3.forceCollide(d => d.r + 1);

		// use the force
		let simulation = d3.forceSimulation()
			// .force('link', d3.forceLink().id(d => d.id))
			.force('charge', d3.forceManyBody())
			.force('collide', forceCollide)
			// .force('center', d3.forceCenter(centerX, centerY))
			.force('x', d3.forceX(centerX ).strength(strength))
			.force('y', d3.forceY(centerY ).strength(strength));

		// reduce number of circles on mobile screen due to slow computation
		if ('matchMedia' in window && window.matchMedia('(max-device-width: 767px)').matches) {
			data = data.filter(el => {
				return el.value >= 50;
			});
		}

		let root = d3.hierarchy({ children: data })
			.sum(d => d.value);

		// we use pack() to automatically calculate radius conveniently only
		// and get only the leaves
		let nodes = pack(root).leaves().map(node => {
			console.log('node:', node.x, (node.x - centerX) * 2);
			const data = node.data;
			return {
				x: centerX + (node.x - centerX) * 3, // magnify start position to have transition to center movement
				y: centerY + (node.y - centerY) * 3,
				r: 0, // for tweening
				radius: node.r, //original radius
				id: data.cat + '.' + (data.name.replace(/\s/g, '-')),
				cat: data.cat,
				name: data.name,
				value: data.value,
				icon: data.icon,
				desc: data.desc,
			}
		});
		simulation.nodes(nodes).on('tick', ticked);
		svg.style('background-color', '#eee');
		let node = svg.selectAll('.node')
			.data(nodes)
			.enter().append('g')
			.attr('class', 'node')
			.call(d3.drag()
				.on('start', (d) => {
					if (!d3.event.active) simulation.alphaTarget(0.2).restart();
					d.fx = d.x;
					d.fy = d.y;
				})
				.on('drag', (d) => {
					d.fx = d3.event.x;
					d.fy = d3.event.y;
				})
				.on('end', (d) => {
					if (!d3.event.active) simulation.alphaTarget(0);
					d.fx = null;
					d.fy = null;
				}));

		node.append('circle')
			.attr('id', d => d.id)
			.attr('r', 0)
			.style('fill', d => scaleColor(d.cat))
			.transition().duration(2000).ease(d3.easeElasticOut)
				.tween('circleIn', (d) => {
					let i = d3.interpolateNumber(0, d.radius);
					return (t) => {
						d.r = i(t);
						simulation.force('collide', forceCollide);
					}
				})

		node.append('clipPath')
			.attr('id', d => `clip-\${d.id}`)
			.append('use')
			.attr('xlink:href', d => `#\${d.id}`);

		// display text as circle icon
		node.filter(d => !String(d.icon).includes('img/'))
			.append('text')
			.classed('node-icon', true)
			.attr('clip-path', d => `url(#clip-\${d.id})`)
			.selectAll('tspan')
			.data(d => d.icon.split(';'))
			.enter()
				.append('tspan')
				.attr('x', 0)
				.attr('y', (d, i, nodes) => (13 + (i - nodes.length / 2 - 0.5) * 10))
				.text(name => name);
		
		// display image as circle icon
		node.filter(d => String(d.icon).includes('img/'))
			.append('image')
			.classed('node-icon', true)
			.attr('clip-path', d => `url(#clip-\${d.id})`)
			.attr('xlink:href', d => d.icon)
			.attr('x', d => - d.radius * 1.5)
			.attr('y', d => - d.radius * 1.5)
			.attr('height', d => d.radius * 2 * 1.5)
			.attr('width', d => d.radius * 2 * 1.5)
			
		node.append('title')
			.text(d => (d.cat + '::' + d.name + '\n' + format(d.value)));

/* 		let legendOrdinal = d3.legendColor()
			.scale(scaleColor)
			.shape('circle');

		let legend = svg.append('g')
			.classed('legend-color', true)
			.attr('text-anchor', 'start')
			.attr('transform','translate(20,30)')
			.style('font-size','12px')
			.call(legendOrdinal);

		let sizeScale = d3.scaleOrdinal()
  			.domain(['less use', 'more use'])
  			.range([5, 10] );

		let legendSize = d3.legendSize()
			.scale(sizeScale)
			.shape('circle')
			.shapePadding(10)
			.labelAlign('end');

		let legend2 = svg.append('g')
			.classed('legend-size', true)
			.attr('text-anchor', 'start')
			.attr('transform', 'translate(150, 25)')
			.style('font-size', '12px')
			.call(legendSize); */


		/*
		<foreignObject class="circle-overlay" x="10" y="10" width="100" height="150">
			<div class="circle-overlay__inner">
				<h2 class="circle-overlay__title">ReactJS</h2>
				<p class="circle-overlay__body">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, sunt, aspernatur. Autem repudiandae, laboriosam. Nulla quidem nihil aperiam dolorem repellendus pariatur, quaerat sed eligendi inventore ipsa natus fugiat soluta doloremque!</p>
			</div>
		</foreignObject>
		*/
		let infoBox = node.append('foreignObject')
			.classed('circle-overlay hidden', true)
			.attr('x', -350 * 0.5 * 0.8)
			.attr('y', -350 * 0.5 * 0.8)
			.attr('height', 350 * 0.8)
			.attr('width', 350 * 0.8)
				.append('xhtml:div')
				.classed('circle-overlay__inner', true);

		infoBox.append('h2')
			.classed('circle-overlay__title', true)
			.text(d => d.name);

		infoBox.append('p')
			.classed('circle-overlay__body', true)
			.html(d => d.desc);


		node.on('click', (currentNode) => {
			d3.event.stopPropagation();
			console.log('currentNode', currentNode);
			let currentTarget = d3.event.currentTarget; // the <g> el

			if (currentNode === focusedNode) {
				// no focusedNode or same focused node is clicked
				return;
			}
			let lastNode = focusedNode;
			focusedNode = currentNode;

			simulation.alphaTarget(0.2).restart();
			// hide all circle-overlay
			d3.selectAll('.circle-overlay').classed('hidden', true);
			d3.selectAll('.node-icon').classed('node-icon--faded', false);

			// don't fix last node to center anymore
			if (lastNode) {
				lastNode.fx = null;
				lastNode.fy = null;
				node.filter((d, i) => i === lastNode.index)
					.transition().duration(2000).ease(d3.easePolyOut)
					.tween('circleOut', () => {
						let irl = d3.interpolateNumber(lastNode.r, lastNode.radius);
						return (t) => {
							lastNode.r = irl(t);
						}
					})
					.on('interrupt', () => {
						lastNode.r = lastNode.radius;
					});
			}

			// if (!d3.event.active) simulation.alphaTarget(0.5).restart();

			d3.transition().duration(2000).ease(d3.easePolyOut)
				.tween('moveIn', () => {
					console.log('tweenMoveIn', currentNode);
					let ix = d3.interpolateNumber(currentNode.x, centerX);
					let iy = d3.interpolateNumber(currentNode.y, centerY);
					let ir = d3.interpolateNumber(currentNode.r, centerY * 0.5);
					return function (t) {
						// console.log('i', ix(t), iy(t));
						currentNode.fx = ix(t);
						currentNode.fy = iy(t);
						currentNode.r = ir(t);
						simulation.force('collide', forceCollide);
					};
				})
				.on('end', () => {
					simulation.alphaTarget(0);
					let $currentGroup = d3.select(currentTarget);
					$currentGroup.select('.circle-overlay')
						.classed('hidden', false);
					$currentGroup.select('.node-icon')
						.classed('node-icon--faded', true);

				})
				.on('interrupt', () => {
					console.log('move interrupt', currentNode);
					currentNode.fx = null;
					currentNode.fy = null;
					simulation.alphaTarget(0);
				});

		});

		// blur
		d3.select(document).on('click', () => {
			let target = d3.event.target;
			// check if click on document but not on the circle overlay
			if (!target.closest('#circle-overlay') && focusedNode) {
				focusedNode.fx = null;
				focusedNode.fy = null;
				simulation.alphaTarget(0.2).restart();
				d3.transition().duration(2000).ease(d3.easePolyOut)
					.tween('moveOut', function () {
						console.log('tweenMoveOut', focusedNode);
						let ir = d3.interpolateNumber(focusedNode.r, focusedNode.radius);
						return function (t) {
							focusedNode.r = ir(t);
							simulation.force('collide', forceCollide);
						};
					})
					.on('end', () => {
						focusedNode = null;
						simulation.alphaTarget(0);
					})
					.on('interrupt', () => {
						simulation.alphaTarget(0);
					});

				// hide all circle-overlay
				d3.selectAll('.circle-overlay').classed('hidden', true);
				d3.selectAll('.node-icon').classed('node-icon--faded', false);
			}
		});
	
		function ticked() {
			node
				.attr('transform', d => `translate(\${d.x},\${d.y})`)
				.select('circle')
					.attr('r', d => d.r);
		}
		
	</script>
</body>
</html>