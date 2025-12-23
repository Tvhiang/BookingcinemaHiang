package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Showtime {
	private int showtimeId;
	private int movieId;
	private int roomId;
	private Timestamp showDate;
	private BigDecimal basePrice;
	private boolean active;

	public Showtime() {
	}

	public Showtime(int showtimeId, int movieId, int roomId, Timestamp showDate, BigDecimal basePrice, boolean active) {
		this.showtimeId = showtimeId;
		this.movieId = movieId;
		this.roomId = roomId;
		this.showDate = showDate;
		this.basePrice = basePrice;
		this.active = active;
	}

	public int getShowtimeId() {
		return showtimeId;
	}

	public void setShowtimeId(int showtimeId) {
		this.showtimeId = showtimeId;
	}

	public int getMovieId() {
		return movieId;
	}

	public void setMovieId(int movieId) {
		this.movieId = movieId;
	}

	public int getRoomId() {
		return roomId;
	}

	public void setRoomId(int roomId) {
		this.roomId = roomId;
	}

	public Timestamp getShowDate() {
		return showDate;
	}

	public void setShowDate(Timestamp showDate) {
		this.showDate = showDate;
	}

	public BigDecimal getBasePrice() {
		return basePrice;
	}

	public void setBasePrice(BigDecimal basePrice) {
		this.basePrice = basePrice;
	}

	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}
}
