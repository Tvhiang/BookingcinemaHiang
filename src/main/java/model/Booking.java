package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Booking {
	private int bookingId;
	private int userId;
	private int showtimeId;
	private Timestamp bookingTime;
	private BigDecimal totalAmount;
	private String paymentStatus; // PENDING, PAID, CANCELLED
	private Timestamp updatedAt;

	public Booking()
	{
		
	}
	public Booking(int bookingId, int userId, int showtimeId, Timestamp bookingTime, BigDecimal totalAmount,
			String paymentStatus, Timestamp updatedAt) {
		this.bookingId = bookingId;
		this.userId = userId;
		this.showtimeId = showtimeId;
		this.bookingTime = bookingTime;
		this.totalAmount = totalAmount;
		this.paymentStatus = paymentStatus;
		this.updatedAt = updatedAt;
	}

	public int getBookingId() {
		return bookingId;
	}

	public void setBookingId(int bookingId) {
		this.bookingId = bookingId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getShowtimeId() {
		return showtimeId;
	}

	public void setShowtimeId(int showtimeId) {
		this.showtimeId = showtimeId;
	}

	public Timestamp getBookingTime() {
		return bookingTime;
	}

	public void setBookingTime(Timestamp bookingTime) {
		this.bookingTime = bookingTime;
	}

	public BigDecimal getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public Timestamp getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}
}
