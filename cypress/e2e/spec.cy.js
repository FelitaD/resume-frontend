describe('My First Test', () => {
  it('Visits resume website', () => {
    cy.visit('https://felitadonor.com')

    cy.contains('Visitor Count:')
  })
})