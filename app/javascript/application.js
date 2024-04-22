// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

/******************
 * DISPLAY ERRORS *
 ******************/
function displayError() {
  const errorBanner = document.getElementById("error-banner");
  const errorMessage = document.getElementById("error-message");

  const showErrorBanner = (error) => {
    errorMessage.textContent = error;
    errorBanner.classList.add("show");
    setTimeout(() => {
      errorBanner.classList.remove("show");
    }, 8000); // Hide after 8 seconds
  };

  // Check if error message is present
  const error = errorBanner.dataset.error;
  if (error) {
    // Display error message
    showErrorBanner(error);
  }
}

/*****************
 * ALREADY RATED *
 *****************/
function disableRatingButtonsWhenAlreadyRated() {
  const message = "Hey! Tu as déjà noté cette prediction ;)";
  const likeButton = document.querySelector("button[value='positive']");
  likeButton.addEventListener("mouseover", function (event) {
    if (event.target.disabled) {
      event.target.style.cursor = "not-allowed";
      event.target.title = message;
    }
  });
}

/**************
 * CONTROLLER *
 **************/
document.addEventListener("DOMContentLoaded", function () {
  displayError();
  disableRatingButtonsWhenAlreadyRated();
});
