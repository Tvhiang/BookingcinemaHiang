package model;

import java.math.BigDecimal;

public class BookingSeat {
	private int bookingSeatId;
	private int bookingId;
	private int seatId;
	private BigDecimal seatPrice;


	public BookingSeat(int bookingSeatId, int bookingId, int seatId, BigDecimal seatPrice) {
		this.bookingSeatId = bookingSeatId;
		this.bookingId = bookingId;
		this.seatId = seatId;
		this.seatPrice = seatPrice;
	}

	public int getBookingSeatId() {
		return bookingSeatId;
	}

	public void setBookingSeatId(int bookingSeatId) {
		this.bookingSeatId = bookingSeatId;
	}

	public int getBookingId() {
		return bookingId;
	}

	public void setBookingId(int bookingId) {
		this.bookingId = bookingId;
	}

	public int getSeatId() {
		return seatId;
	}

	public void setSeatId(int seatId) {
		this.seatId = seatId;
	}

	public BigDecimal getSeatPrice() {
		return seatPrice;
	}

	public void setSeatPrice(BigDecimal seatPrice) {
		this.seatPrice = seatPrice;
	}
}
