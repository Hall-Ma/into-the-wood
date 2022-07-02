from selenium import webdriver
from selenium.webdriver.common.by import By
import requests
import io
from PIL import Image
import time
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service


service = Service("chromedriver.exe")

options = Options()
options.add_argument("--headless")  # Runs Chrome in headless mode.
options.add_argument('--no-sandbox')  # Bypass OS security model
options.add_argument('--disable-gpu')  # applicable to windows os only
options.add_argument('start-maximized')
options.add_argument('disable-infobars')
options.add_argument("--disable-extensions")

wd = webdriver.Chrome(options=options, service=service)


def get_images_from_google(wd, delay, max_images):
    def scroll_down(wd):
        wd.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(delay)

    url = "https://www.google.com/search?q=esche+blatt&tbm=isch&ved=2ahUKEwi5jtD7qMP3AhUDsKQKHTcSDlcQ2-cCegQIABAA&oq" \
          "=esche+blatt&gs_lcp" \
          "=CgNpbWcQAzIHCCMQ7wMQJzIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDoGCAAQCBAeUIYJWIYJYKkPaABwAHgAgAFBiAF-kgEBMpgBAKABAaoBC2d3cy13aXotaW1nwAEB&sclient=img&ei=fB5xYrngMYPgkgW3pLi4BQ&bih=802&biw=1522&rlz=1C1CHBF_deDE990DE990"

    image_urls = set()
    skips = 0

    wd.get(url)
    while len(image_urls) + skips < max_images:
        scroll_down(wd)

        thumbnails = wd.find_elements(By.CLASS_NAME, "Q4LuWd")

        for img in thumbnails[len(image_urls) + skips:max_images]:
            try:
                img.click()
                time.sleep(delay)
            except:
                continue

            images = wd.find_elements(By.CLASS_NAME, "n3VNCb")
            for image in images:
                if image.get_attribute('src') in image_urls:
                    max_images += 1
                    skips += 1
                    break

                if image.get_attribute('src') and 'http' in image.get_attribute('src'):
                    image_urls.add(image.get_attribute('src'))
                    print(f"Found {len(image_urls)}")
    return image_urls


def download_image(download_path, url, file_name):
    try:
        image_content = requests.get(url).content
        image_file = io.BytesIO(image_content)
        image = Image.open(image_file)
        file_path = download_path + file_name

        with open(file_path, "wb") as f:
            image.save(f, "JPEG")

        print("Success")
    except Exception as e:
        print('FAILED -', e)


urls = get_images_from_google(wd, 1, 300)

for i, url in enumerate(urls):
    download_image("data/trees/ash/ash_", url, str(i) + ".jpg")

wd.quit()
