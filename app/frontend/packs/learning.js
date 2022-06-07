  document.addEventListener("turbolinks:load", function() {
    const el = document.querySelector("div.carousel div.carousel-inner div.carousel-item");
    if (el) el.classList.add("active");
  });
