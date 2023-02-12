//put js code

var load = document.querySelector(".preloader");

window.addEventListener("load", () => {
  load.style.display = "none";
});

/*
--------------------------------------------------------------------------------------------
*/

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

/*
--------------------------------------------------------------------------------------------
*/

const text = document.querySelector("#text-change");
var names = ["keenan Tobiansky", "Vincent Raoul"];
var count = 0;
function change() {
  text.innerHTML = names[count];
  console.log(names[count]);
  count++;
  if (count >= names.length) {
    count = 0;
  }
}
setInterval(change, 2000);

/*
--------------------------------------------------------------------------------------------
*/

//paralax
