/* Sök på sajten. Hämtar /sok.json första gången rutan öppnas och matchar
   på delsträng i titel och text. Med tolv sidor behövs inget sökindex. */
(function () {
  "use strict";

  var knapp = document.getElementById("sok-knapp");
  var ruta = document.getElementById("sok");
  var falt = document.getElementById("sok-falt");
  var traffar = document.getElementById("sok-traffar");
  if (!knapp || !ruta || !falt || !traffar) return;

  var poster = null;

  // gemener och utan diakriter, så att "kafe" hittar "kafé"
  function normalisera(text) {
    return text.toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "");
  }

  function visa(fraga) {
    traffar.textContent = "";
    if (!poster || normalisera(fraga).length < 2) return;

    var sokord = normalisera(fraga);
    poster
      .filter(function (p) {
        return normalisera(p.titel + " " + p.text).indexOf(sokord) !== -1;
      })
      .slice(0, 8)
      .forEach(function (p) {
        var li = document.createElement("li");
        var a = document.createElement("a");
        a.href = p.url;
        a.textContent = p.titel;
        var utdrag = document.createElement("p");
        utdrag.textContent = p.text.slice(0, 140) + "…";
        li.appendChild(a);
        li.appendChild(utdrag);
        traffar.appendChild(li);
      });
  }

  knapp.addEventListener("click", function () {
    var oppen = ruta.hidden;
    ruta.hidden = !oppen;
    knapp.setAttribute("aria-expanded", String(oppen));
    if (!oppen) return;

    falt.focus();
    if (poster) return;
    fetch("/sok.json")
      .then(function (svar) { return svar.json(); })
      .then(function (data) {
        poster = data;
        visa(falt.value);
      })
      .catch(function () {
        traffar.textContent = "Sökningen kunde inte laddas.";
      });
  });

  falt.addEventListener("input", function () { visa(falt.value); });

  falt.addEventListener("keydown", function (e) {
    if (e.key !== "Escape") return;
    ruta.hidden = true;
    knapp.setAttribute("aria-expanded", "false");
    knapp.focus();
  });
})();
