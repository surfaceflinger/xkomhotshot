#!/usr/bin/env python3
import asyncio
import requests
from telegram import Bot
from telegram.constants import ParseMode

# Load API credentials from the settings file
with open('/var/lib/xkomhotshot/settings.txt', 'r') as file:
    lines = file.readlines()
    token = lines[0].strip()
    channel = lines[1].strip()

API_HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:82.0) Gecko/20100101 Firefox/82.0",
    "X-API-Key": "sJSgnQXySmp6pqNV",
}

API_URL = "https://mobileapi.x-kom.pl/api/v1/xkom/hotShots/current?onlyHeader=false"

def get_hot_shot():
    response = requests.get(url=API_URL, headers=API_HEADERS).json()
    hot_shot_info = {
        "name": response['PromotionName'],
        "price": response['Price'],
        "old_price": response['OldPrice'],
        "link": f"https://www.x-kom.pl/goracy_strzal/{response['Id']}",
        "photo_url": response['Product']['MainPhoto']['Url'],
    }
    return hot_shot_info

async def main():
    bot = Bot(token)
    hot_shot_data = get_hot_shot()
    description = (
        f"Item: {hot_shot_data['name']}\n"
        f"Cena: {hot_shot_data['price']} PLN\n"
        f"Stara cena: {hot_shot_data['old_price']} PLN\n"
        f"Link: {hot_shot_data['link']}"
    )
    try:
        await bot.send_photo(chat_id=channel, photo=hot_shot_data['photo_url'], caption=description, parse_mode=ParseMode.MARKDOWN)
    except Exception as e:
        await bot.send_message(chat_id=channel, text=description)

if __name__ == '__main__':
    asyncio.run(main())
