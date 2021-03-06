package poly.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import poly.dto.admin.ADMIN_ImageDTO;

public interface ADMIN_IImageService {
	public int Image_Add(ADMIN_ImageDTO imgDTO) throws Exception;
	public String getFile_Seq() throws Exception;
	public ADMIN_ImageDTO getImageInfo(String file_id) throws Exception;
	public int Image_Edit(ADMIN_ImageDTO imgDTO) throws Exception;
	public int Image_Delete(String file_id) throws Exception;
	public List<ADMIN_ImageDTO> getMenuImage(List<String> temporary) throws Exception;
}
