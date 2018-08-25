package poly.controller;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.OutputStreamWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.rosuda.REngine.Rserve.RConnection;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import poly.dto.consumer.CONSUMER_FtLikeDTO;
import poly.dto.consumer.CONSUMER_FtMenuCateDTO;
import poly.dto.consumer.CONSUMER_Ft_InfoDTO;
import poly.dto.consumer.CONSUMER_Ft_ReviewDTO;
import poly.dto.consumer.CONSUMER_ImageDTO;
import poly.dto.consumer.CONSUMER_Menu_InfoDTO;
import poly.dto.consumer.CONSUMER_RcmmndMenuDTO;
import poly.dto.consumer.CONSUMER_UserDTO;
import poly.service.CONSUMER_IFtService;
import poly.util.CmmUtil;
import poly.util.GeoUtil;
import poly.util.RServe;
import poly.util.CONSUMER_UtilFile;
import poly.util.SortTruck;
import poly.util.UtilRegex;
import poly.service.CONSUMER_IImageService;
import poly.service.CONSUMER_IUserService;
import poly.service.impl.CONSUMER_ImageService;
import poly.service.impl.CONSUMER_UserService;

/*
 * Controller 선언해야만 Spring 프레임워크에서 Controller인지 인식 가능
 * 자바 서블릿 역할 수행
 * */
@Controller
public class CONSUMER_DataAnalysisController {
	private Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "CONSUMER_FtService")
	private CONSUMER_IFtService ftService;
	
	@RequestMapping(value="consumer/rcmmnd/rcmmndMenu", method=RequestMethod.GET)
	public String rcmmndMenu(HttpServletRequest request, Model model) throws Exception{
			log.info("Access rcmmndMenu.........");
			
			String sido = "서울"; //임시 테스트
			
			List<CONSUMER_RcmmndMenuDTO> rcmmndMenuDTO = ftService.getRcmmndMenuList(sido);
			
			
			log.info("Terminate rcmmndMenu.........");
			return "/consumer/rcmmnd/rcmmndMenu";
	}
	
	
	
}
