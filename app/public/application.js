let buttonStates = ['off', 'on', 'start', 'finish']

document.querySelectorAll('form.toggleLight').forEach(form => {
  form.addEventListener('submit', event => {
    event.preventDefault();
    fetch(form.action, { method: 'POST' })

    let button = event.target.querySelector('input[type="submit"]');
    let index = buttonStates.indexOf(button.getAttribute('data-state'))
    button.setAttribute('data-state', buttonStates[index + 1]);
  })
})
