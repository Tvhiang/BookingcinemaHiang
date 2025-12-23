package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class BookingRow {
    private int bookingId;
    private int userId;
    private String username;

    private int showtimeId;
    private Timestamp showDate;      // showtimes.show_date
    private String movieTitle;       // movies.title
    private String roomName;         // rooms.room_name

    private Timestamp bookingTime;
    private BigDecimal totalAmount;
    private String paymentStatus;

    public BookingRow() {}

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getShowtimeId() { return showtimeId; }
    public void setShowtimeId(int showtimeId) { this.showtimeId = showtimeId; }

    public Timestamp getShowDate() { return showDate; }
    public void setShowDate(Timestamp showDate) { this.showDate = showDate; }

    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public Timestamp getBookingTime() { return bookingTime; }
    public void setBookingTime(Timestamp bookingTime) { this.bookingTime = bookingTime; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
}
