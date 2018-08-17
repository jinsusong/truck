package poly.service.impl;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import poly.dto.consumer.CONSUMER_FtLikeDTO;
import poly.dto.consumer.CONSUMER_Ft_InfoDTO;
import poly.dto.consumer.CONSUMER_Ft_ReviewDTO;
import poly.dto.consumer.CONSUMER_GpsTableDTO;
import poly.dto.consumer.CONSUMER_ImageDTO;
import poly.dto.consumer.CONSUMER_Menu_InfoDTO;
import poly.persistance.mapper.CONSUMER_FtMapper;
import poly.persistance.mapper.CONSUMER_Ft_ReviewMapper;
import poly.service.CONSUMER_IFtService;

@Service("CONSUMER_FtService") //단순한 이름 설정

public class CONSUMER_FtService implements CONSUMER_IFtService{ //IUserService를 상속받는 UserService 인터페이스
	@Resource(name="CONSUMER_FtMapper")	// 객체를 생성할 때 UserMapper라고 명명
	private CONSUMER_FtMapper ftMapper; // UserMapper 타입의 userMapper라는 변수의 객체 선언

	@Resource(name="CONSUMER_Ft_ReviewMapper")	// 객체를 생성할 때 UserMapper라고 명명
	private CONSUMER_Ft_ReviewMapper ft_ReviewMapper; // UserMapper 타입의 userMapper라는 변수의 객체 선언


	@Override
	public List<CONSUMER_Ft_InfoDTO> getFtList(String regCode) throws Exception {
		return ftMapper.getFtList(regCode);
	}


	@Override
	public CONSUMER_Ft_InfoDTO getFtDetail(String ft_seq) throws Exception {
		return ftMapper.getFtDetail(ft_seq);
	}


	@Override
	public List<CONSUMER_Ft_ReviewDTO> getReviewDetail(String ft_seq) throws Exception {
		return ftMapper.getReviewDetail(ft_seq);
	}


	@Override
	public List<CONSUMER_Menu_InfoDTO> getMenuList(String keyWord) throws Exception {
		return ftMapper.getMenuList(keyWord);
	}


	@Override
	public List<CONSUMER_ImageDTO> getTruckImage(List<CONSUMER_ImageDTO> ImgDTOs) throws Exception {
		return ftMapper.getTruckImage(ImgDTOs);
	}


	@Override
	public List<CONSUMER_ImageDTO> getReviewImage(List<CONSUMER_ImageDTO> ImgDTOs) throws Exception {
		return ftMapper.getReviewImage(ImgDTOs);
	}


	@Override
	public List<CONSUMER_ImageDTO> getBannerImages() throws Exception {
		return ftMapper.getBannerImages();
	}


	@Override
	public List<CONSUMER_Menu_InfoDTO> getFtMenuList(String ft_seq) throws Exception {
		return ftMapper.getFtMenuList(ft_seq);
	}


	@Override
	public List<CONSUMER_ImageDTO> getMenuImage(List<CONSUMER_ImageDTO> imgDTOs) throws Exception {
		return ftMapper.getMenuImage(imgDTOs);
	}


	@Override
	public CONSUMER_ImageDTO getFtImage(String file_id) throws Exception {
		return ftMapper.getFtImage(file_id);
	}



//푸드트럭 리뷰관리-------------------------------------------------------------
	@Override
	public List<CONSUMER_Ft_ReviewDTO> getFT_Review_List(int ft_seq) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.getFT_Review_List(ft_seq);
	} 

	@Override
	public CONSUMER_Ft_ReviewDTO getFT_Review_Info(int review_seq) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.getFT_Review_Info(review_seq);
	}

	@Override
	public int ft_Review_Delete(int review_seq) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.ft_Review_Delete(review_seq);
	}

	@Override
	public int ft_Review_Exp_Yn(int review_seq) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.ft_Review_Exp_Yn(review_seq);
	}

	@Override
	public int ft_Review_Edit(CONSUMER_Ft_ReviewDTO revDTO) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.ft_Review_Edit(revDTO);
	}

	@Override
	public int ft_Review_Create(CONSUMER_Ft_ReviewDTO revDTO) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.ft_Review_Create(revDTO);
	}

	@Override
	public int ft_Set_Rev_level(int review_seq) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.ft_Set_Rev_level(review_seq);
	}

	@Override
	public int ft_Set_Revp_level(CONSUMER_Ft_ReviewDTO revDTO) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.ft_Set_Revp_level(revDTO);
	}

	@Override
	public List<CONSUMER_Ft_ReviewDTO> getReview_LevP_List(String search_level) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.getReview_LevP_List(search_level);
	}

	@Override
	public int getReview_Reple_Cnt(String search_level) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.getReview_Reple_Cnt(search_level);
	}

	@Override
	public int ft_Review_Reple_Edit(CONSUMER_Ft_ReviewDTO revDTO) throws Exception {
		// TODO Auto-generated method stub
		return ft_ReviewMapper.ft_Review_Reple_Edit(revDTO);
	}


	@Override
	public List<CONSUMER_Ft_ReviewDTO> getFt_Review_List_ftDetail(int ft_seq) throws Exception{
		return ft_ReviewMapper.getFt_Review_List_ftDetail(ft_seq);
	}





}




