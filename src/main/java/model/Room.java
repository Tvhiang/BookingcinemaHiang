package model;

public class Room {
	private int roomId;
	private String roomName;
	private Integer totalRows;
	private Integer totalCols;

	public Room() {
	}

	public Room(int roomId, String roomName, Integer totalRows, Integer totalCols) {
		this.roomId = roomId;
		this.roomName = roomName;
		this.totalRows = totalRows;
		this.totalCols = totalCols;
	}

	public int getRoomId() {
		return roomId;
	}

	public void setRoomId(int roomId) {
		this.roomId = roomId;
	}

	public String getRoomName() {
		return roomName;
	}

	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}

	public Integer getTotalRows() {
		return totalRows;
	}

	public void setTotalRows(Integer totalRows) {
		this.totalRows = totalRows;
	}

	public Integer getTotalCols() {
		return totalCols;
	}

	public void setTotalCols(Integer totalCols) {
		this.totalCols = totalCols;
	}
}
