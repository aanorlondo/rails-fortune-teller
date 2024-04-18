// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

/******************
 * DISPLAY ERRORS *
 ******************/

document.addEventListener("DOMContentLoaded", function () {
  const errorBanner = document.getElementById("error-banner");
  const errorMessage = document.getElementById("error-message");

  const showErrorBanner = (error) => {
    errorMessage.textContent = error;
    errorBanner.classList.add("show");
    setTimeout(() => {
      errorBanner.classList.remove("show");
    }, 5000); // Hide after 5 seconds
  };

  // Check if error message is present
  const error = errorBanner.dataset.error;
  if (error) {
    // Display error message
    showErrorBanner(error);
  }
});
