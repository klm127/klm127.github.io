// div for testing -jekyll

document.addEventListener('DOMContentLoaded', (event) => {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    let container = document.getElementById("tag-container");
    for(let tag of container.children ) {
        if( tag.id != "-"+urlParams.get('tag')) {
            tag.innerHTML = '';
        }
    };
});