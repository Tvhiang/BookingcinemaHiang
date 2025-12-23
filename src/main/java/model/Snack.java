package model;

import java.math.BigDecimal;

public class Snack {
	private int snackId;
	private String snackName;
	private String category; 
	private BigDecimal price;
	private String imageUrl;
	private BigDecimal discount;
	//contructor rỗng
	public Snack() {
		
	}
	public Snack(int snackId, String snackName, String category, BigDecimal price, String imageUrl,
			BigDecimal discount) {
		this.snackId = snackId;
		this.snackName = snackName;
		this.category = category;
		this.price = price;
		this.imageUrl = imageUrl;
		this.discount = discount;
	}

	public int getSnackId() {
		return snackId;
	}

	public void setSnackId(int snackId) {
		this.snackId = snackId;
	}

	public String getSnackName() {
		return snackName;
	}

	public void setSnackName(String snackName) {
		this.snackName = snackName;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public BigDecimal getDiscount() {
		return discount;
	}

	public void setDiscount(BigDecimal discount) {
		this.discount = discount;
	}
}
