package model;

import java.sql.Date;

public class Movie {
	private int movieId;
	private String title;
	private String genre;
	private Integer duration;
	private String description;
	private String director;
	private String cast;
	private String posterUrl;
	private String ageRating;
	private Date releaseDate;
	private String status;

	//Constructor rỗng
		public Movie() {
			
		}
	public Movie(int movieId, String title, String genre, Integer duration, String description, String director,
			String cast, String posterUrl, String ageRating, Date releaseDate, String status) {
		this.movieId = movieId;
		this.title = title;
		this.genre = genre;
		this.duration = duration;
		this.description = description;
		this.director = director;
		this.cast = cast;
		this.posterUrl = posterUrl;
		this.ageRating = ageRating;
		this.releaseDate = releaseDate;
		this.status = status;
	}
	// getters & setters
	public int getMovieId() {
		return movieId;
	}

	public void setMovieId(int movieId) {
		this.movieId = movieId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getGenre() {
		return genre;
	}

	public void setGenre(String genre) {
		this.genre = genre;
	}

	public Integer getDuration() {
		return duration;
	}

	public void setDuration(Integer duration) {
		this.duration = duration;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDirector() {
		return director;
	}

	public void setDirector(String director) {
		this.director = director;
	}

	public String getCast() {
		return cast;
	}

	public void setCast(String cast) {
		this.cast = cast;
	}

	public String getPosterUrl() {
		return posterUrl;
	}

	public void setPosterUrl(String posterUrl) {
		this.posterUrl = posterUrl;
	}

	public String getAgeRating() {
		return ageRating;
	}

	public void setAgeRating(String ageRating) {
		this.ageRating = ageRating;
	}

	public Date getReleaseDate() {
		return releaseDate;
	}

	public void setReleaseDate(Date releaseDate) {
		this.releaseDate = releaseDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
