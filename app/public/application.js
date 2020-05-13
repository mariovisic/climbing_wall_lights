let buttonStates = ['off', 'on', 'start', 'finish']

document.querySelectorAll('form.toggleLight').forEach(form => {
  form.addEventListener('submit', event => {
    // TODO: Submit form via AJAX if it has an action :) 
    let button = event.target.querySelector('input[type="submit"]');
    let index = buttonStates.indexOf(button.getAttribute('data-state'))
    button.setAttribute('data-state', buttonStates[index + 1]);
  })
})
