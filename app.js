//put js code

const observe = new IntersectionObserver((el) => {
  el.forEach((element) => {
    if (element.isIntersecting) {
      element.target.classList.add("open");
    } else {
      element.target.classList.remove("open");
    }
  });
});

const all_text_sections = document.querySelectorAll(".not-open");

all_text_sections.forEach((element) => observe.observe(element));
