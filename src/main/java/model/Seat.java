package model;

public class Seat {
	private int seatId;
	private int roomId;
	private int seatRow;
	private int seatCol;
	private String seatLabel;

	public Seat(int seatId, int roomId, int seatRow, int seatCol, String seatLabel) {
		this.seatId = seatId;
		this.roomId = roomId;
		this.seatRow = seatRow;
		this.seatCol = seatCol;
		this.seatLabel = seatLabel;
	}

	public int getSeatId() {
		return seatId;
	}

	public void setSeatId(int seatId) {
		this.seatId = seatId;
	}

	public int getRoomId() {
		return roomId;
	}

	public void setRoomId(int roomId) {
		this.roomId = roomId;
	}

	public int getSeatRow() {
		return seatRow;
	}

	public void setSeatRow(int seatRow) {
		this.seatRow = seatRow;
	}

	public int getSeatCol() {
		return seatCol;
	}

	public void setSeatCol(int seatCol) {
		this.seatCol = seatCol;
	}

	public String getSeatLabel() {
		return seatLabel;
	}

	public void setSeatLabel(String seatLabel) {
		this.seatLabel = seatLabel;
	}
}
