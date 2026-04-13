document.addEventListener("DOMContentLoaded", () => {
  // Course Filter Logic
  document.getElementById("course-search")?.addEventListener("keyup", function() {
    let filter = this.value.toLowerCase();
    let courseItems = document.querySelectorAll(".course-item");

    courseItems.forEach(function(item) {
      let text = item.textContent.toLowerCase();
      item.style.display = text.includes(filter) ? "" : "none";
    });
  });

  // Add availability
  document.getElementById("add-availability")?.addEventListener("click", function() {
    let container = document.getElementById("availabilities-container");
    let template = document.getElementById("availability-template").innerHTML;

    let uniqueId = new Date().getTime();
    let newRowHtml = template.replace(/NEW_RECORD/g, uniqueId);

    container.insertAdjacentHTML('beforeend', newRowHtml);
  });

  // Remove availability
  document.getElementById("availabilities-container")?.addEventListener("click", function(e) {
    if (e.target.classList.contains("remove-availability")) {
      let row = e.target.closest(".availability-row");
      let destroyFlag = row.querySelector(".destroy-flag");

      if (destroyFlag) {
        destroyFlag.value = "1";
        row.style.display = "none";
      } else {
        row.remove();
      }
    }
  });
});