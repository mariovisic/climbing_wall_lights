document.querySelectorAll('form.toggleLight').forEach(form => {
  form.addEventListener('submit', event => {
    if(event.target.querySelector('input[type="submit"]').className.includes('btn-light')) {
      // Remove btn-light from the button
    } else {
      // Add btn-light from the button
    }
  })
})
