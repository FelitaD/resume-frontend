// // Example POST method implementation:
// async function postData(url = "", data = {}) {
//     // Default options are marked with *
//     const response = await fetch(url, {
//       method: "POST", // *GET, POST, PUT, DELETE, etc.
//       mode: "cors", // no-cors, *cors, same-origin
//       cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
//       credentials: "include", // include, *same-origin, omit
//       headers: {
//         "Content-Type": "application/json",
//         // 'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       redirect: "follow", // manual, *follow, error
//       referrerPolicy: "origin", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
//       body: JSON.stringify(data), // body data type must match "Content-Type" header
//     });
//     return response.json(); // parses JSON response into native JavaScript objects
//   }
  
// document.addEventListener('DOMContentLoaded', function() {
//     // Call the postData function when the DOM content is loaded
//     postData("https://gateway-jq4t4jadfq-od.a.run.app/update_visitor_count", { visitor_count: "1" }).then((data) => {
//         console.log(data);
//     });
// });


async function getData(url = "") {
  const fetchPromise = await fetch(url, {
    method: "GET", 
    mode: "cors"
  });
}

document.addEventListener('DOMContentLoaded', function() {
  getData("https://gateway-jq4t4jadfq-od.a.run.app/hello").then((response) => response.json())
  .then((data) => {
    console.log(data);
  });
})


async function postDataTest(url = "", data = {}) {
  const response = await fetch(url, {
    method: "POST", 
    mode: "cors",
    cache: "no-cache",
    credentials: "include",
    headers: {
      'Accept': 'text/html',
      "Content-Type": "text/html",
      },
    referrerPolicy: "origin",
    redirect: "follow",
    body: JSON.stringify(data), // body data type must match "Content-Type" header
  });
  const content = await response.json();
  console.log(content);
  return content;
}

document.addEventListener('DOMContentLoaded', function() {
  postDataTest("https://gateway-jq4t4jadfq-od.a.run.app/update_visitor_count", { visitor_count: "1" }).then((data) => {
    console.log(data);
  });
});
