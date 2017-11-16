package com.paraxialtech.vapals;

import io.github.bonigarcia.wdm.ChromeDriverManager;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.platform.runner.JUnitPlatform;
import org.junit.runner.RunWith;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import javax.annotation.Nonnull;
import java.awt.*;

import static org.apache.commons.lang3.ObjectUtils.defaultIfNull;

@RunWith(JUnitPlatform.class)
public abstract class AbstractFormTest {
    protected static final String SSH_PRIVATE_KEY = defaultIfNull(System.getProperty("privateKey"), "~/.ssh/id_rsa");
    protected static final String SSH_USER = defaultIfNull(System.getProperty("user"), System.getProperty("user.name"));
    protected static final String SERVER = defaultIfNull(System.getProperty("server"), "localhost");
    protected static final String PORT = defaultIfNull(System.getProperty("port"), "9080");
    protected static final String STUDY_IDS = defaultIfNull(System.getProperty("studyIds"), "PA0001");
    protected static WebDriver driver = new HtmlUnitDriver();

    /**
     * Setup the Selenium driver to use an actual Chrome instance or a headless one.
     */
    @BeforeClass
    static void beforeClass() {
        ChromeDriverManager.getInstance().setup();
        if (System.getProperty("headless") != null || GraphicsEnvironment.isHeadless()) {
            final ChromeOptions o = new ChromeOptions();
            o.addArguments("headless");
            driver = new ChromeDriver(o);
        }
        else {
            driver = new ChromeDriver();
        }
    }

    /**
     * Cleanup/destroy our web driver
     */
    @AfterClass
    static void afterClass() {
        driver.quit();
    }

    @Nonnull public abstract String getDataDictionaryFile();
}
