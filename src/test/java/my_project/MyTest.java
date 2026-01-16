package my_project;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.annotations.Test;

public class MyTest {

    WebDriver driver;

    @Test(priority = 1)
    public void launch_google(){
        ChromeOptions option = new ChromeOptions();
        option.addArguments("--headless");
        option.addArguments("--disable-dev-shm-usage");
        option.addArguments("--headless=new");
        driver = new ChromeDriver(option);
        driver.get("https://www.google.com");
    }

    @Test(priority = 2)
    public void getTitle(){

        System.out.println("Title : " +driver.getTitle());
    }

    @Test(priority = 3)
    public void closeBrowser(){

        driver.close();
        driver.quit();
    }
}
