package poly.dto.admin;

public class ADMIN_Gps_TableDTO {
	private int user_seq;
	private int ft_seq;
	private String gps_data;
	private String gps_renew_date;
	
	public int getUser_seq() {
		return user_seq;
	}
	public void setUser_seq(int user_seq) {
		this.user_seq = user_seq;
	}
	public int getFt_seq() {
		return ft_seq;
	}
	public void setFt_seq(int ft_seq) {
		this.ft_seq = ft_seq;
	}
	public String getGps_data() {
		return gps_data;
	}
	public void setGps_data(String gps_data) {
		this.gps_data = gps_data;
	}
	public String getGps_renew_date() {
		return gps_renew_date;
	}
	public void setGps_renew_date(String gps_renew_date) {
		this.gps_renew_date = gps_renew_date;
	}
}
