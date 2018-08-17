package poly.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.swing.plaf.synth.SynthSeparatorUI;

import org.springframework.stereotype.Service;

import poly.dto.seller.SELLER_FtDistrictDataDTO;
import poly.dto.seller.SELLER_FtSellerDTO;
import poly.dto.seller.SELLER_ImageDTO;
import poly.persistance.mapper.SELLER_FtSellerMapper;
import poly.service.SELLER_IFtSellerService;

@Service("SELLER_FtSellerService")//service이름

public class SELLER_FtSellerService implements SELLER_IFtSellerService {

	@Resource(name="SELLER_FtSellerMapper")
	private SELLER_FtSellerMapper sELLER_FtSellerMapper;

	/*@Override
	public int insertFtSInfo(FtSellerDTO ftSDTO) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("FtSellerDTO service :" + ftSDTO.getFtName());
		System.out.println("ftSellerDTO service : " + ftSDTO.getFileId());
		System.out.println("ftSellerDTO service : " + ftSDTO.getFtChan());
		System.out.println("ftSellerDTO service : " + ftSDTO.getFtFunc());
		System.out.println("ftSellerDTO service : " + ftSDTO.getFtIntro());
		System.out.println("ftSellerDTO service : " + ftSDTO.getFtJoin());
		System.out.println("ftSellerDTO service : " + ftSDTO.getFtLoc());
		System.out.println("ftSellerDTO service : " + ftSDTO.getFtOptime());
		System.out.println("ftSellerDTO service : " + ftSDTO.getFtStatus());
		
		
		return ftSellerMapper.insertFtSInfo(ftSDTO);
	}*/

	@Override
	public HashMap<String, Object> insertFtSInfo(HashMap<String, Object> hMap) throws Exception {
		System.out.println("insertFtSInfo service Start!!");
		System.out.println("hMap : " + hMap.get("ftSDTO"));
		System.out.println("hMap : " + hMap.get("imgDTO"));
		
		
		
		SELLER_FtSellerDTO ftsDTO =(SELLER_FtSellerDTO)hMap.get("ftSDTO");
		System.out.println("ftsDTO service : " + ftsDTO.getFtName());
		SELLER_ImageDTO imgDTO = (SELLER_ImageDTO)hMap.get("imgDTO");
		System.out.println("imgDTO . fileId : " + imgDTO.getFileId());
		
		
		
		int resultFtReg = sELLER_FtSellerMapper.insertFtSInfo(ftsDTO);
		System.out.println("resultFtReg : " + resultFtReg);
		
		System.out.println("ftsDTO fileId : " + ftsDTO.getFileId());
		//select key 에서 받아온 값을 String FileId 저장 ?? 
		String FileId =(String)ftsDTO.getFileId();
		System.out.println("fileId : " + FileId);
		imgDTO.setFileId(FileId);
		
		
		int resultImgReg = sELLER_FtSellerMapper.insertftsImg(imgDTO);
		System.out.println("imgDTO . result fileId : " + imgDTO.getFileId());
		System.out.println("resultImgReg : " + resultImgReg);
		
		hMap.put("resultFtReg", resultFtReg);
		hMap.put("resultImgReg",resultImgReg );
		
		
		
		System.out.println("insertFtSInfo service end!!!");
		return hMap;
		
	}

	@Override
	public SELLER_FtSellerDTO getTruckConfig(SELLER_FtSellerDTO ftsDTO) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("truckConfig service : " + ftsDTO.getUserSeq());
		
		return sELLER_FtSellerMapper.getTruckConfig(ftsDTO);
	}

	@Override
	public SELLER_ImageDTO getTruckImage(SELLER_ImageDTO imgDTO) throws Exception {
		System.out.println("truckImage service :" + imgDTO.getUserSeq());
		
		return sELLER_FtSellerMapper.getTruckImage(imgDTO);
	}

	@Override
	public int updateTruckImage(SELLER_ImageDTO imgDTO) throws Exception {
		System.out.println("updateTruckImage : "+ imgDTO.getFileId());
		System.out.println("updateTruckImage : "+ imgDTO.getUserSeq());
		System.out.println("updateTruckImage : "+ imgDTO.getFileOrgname());
		System.out.println("updateTruckImage : " + imgDTO.getFilePath());
		System.out.println("updateTruckImage : " + imgDTO.getFileSevname());
		
		
		
		return sELLER_FtSellerMapper.updateTruckImage(imgDTO);
	}

	@Override
	public List<SELLER_FtDistrictDataDTO> getFtDstctData(String keyWord) throws Exception {
		return sELLER_FtSellerMapper.getFtDstctData(keyWord);
	}
	
}
