require 'watir'
require 'test/unit'

class TestLogin < Test::Unit::TestCase
 
  def test_login_success
    browser = Watir::Browser.new
    browser.goto("http://jinguidev/wlmqxkz/Account/LogonWLMQXKZ")
    browser.text_field(:name, "UserName").set("admin")
    browser.text_field(:name, "Password").set("mima1234")
    browser.button(:value, "登录").click
    assert(browser.text.include?("系统管理员"))
    assert(browser.text.include?("主页"))
    assert(browser.text.include?("注销"))
    browser.goto("http://jinguidev/wlmqxkz/Account/LogOff")
    assert(browser.text.include?("登录"))
    browser.close()
  end

  def test_login_faild
  	browser = Watir::Browser.new
    browser.goto("http://jinguidev/wlmqxkz/Account/LogonWLMQXKZ")
    browser.text_field(:name, "UserName").set("admin")
    browser.text_field(:name, "Password").set("mima")
    browser.button(:value, "登录").click
    assert(browser.text.include?("用户名或密码错误"))
    browser.close()
  end

end