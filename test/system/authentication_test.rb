require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up' do
    visit root_path
    click_on 'Cadastrar'
    
    fill_in 'Email', with: 'gabriel@iugu.com.br'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirmação de senha', with: '12345678'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Boas vindas! Cadastrou e entrou com sucesso'
    assert_text 'gabriel@iugu.com.br'
    assert_link 'Sair'
    assert_no_link 'Cadastrar'
    assert_current_path root_path
  end

  test 'user sign in' do
    user = User.create!(email: 'gabriel@iugu.com.br', password: '12345678')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Login'

    assert_text 'Login efetuado com sucesso!'
    assert_text user.email
    assert_current_path root_path
    assert_link 'Sair'
    assert_no_link 'Entrar'
  end

  test 'user sign out' do
    login_user
    visit root_path
    click_on 'Sair'

    assert_text 'Saiu com sucesso.'
    assert_no_text 'gabriel@iugu.com.br'
    assert_no_link 'Sair'
    assert_link 'Entrar'
    assert_link 'Cadastrar'
    assert_current_path root_path
  end

  test 'and signup fields cannot be blank' do
    visit root_path
    click_on 'Cadastrar'
    within 'form' do
      click_on 'Cadastrar'
    end
    assert_text 'não pode ficar em branco', count: 2
  end

  test 'and login fields cannot be blank' do
    visit root_path
    click_on 'Entrar'
    click_on 'Login'
    assert_text 'Email ou senha inválida.'
  end
 end