let buttonStates = ['off', 'on', 'start', 'finish']

document.querySelectorAll('form.toggleLight').forEach(form => {
  form.addEventListener('submit', event => {
    event.preventDefault();
    fetch(form.action, { method: 'POST' })

    let button = event.target.querySelector('input[type="submit"]');
    let index = Math.max(0, buttonStates.indexOf(button.getAttribute('data-state')))
    button.setAttribute('data-state', buttonStates[index + 1]);
  })
})

document.querySelector('input.brightnessSlider').addEventListener('change', (event) => {
  let form = document.querySelector('form.setBrightness')
  let formData = new FormData();
  formData.append('brightness', event.target.value);

  fetch(form.action, { method: 'POST', body: formData })
})
