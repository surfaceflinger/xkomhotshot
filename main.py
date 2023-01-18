#!/usr/bin/env python3
import asyncio
import requests
from telegram import Bot, Chat
from telegram.constants import ParseMode

with open('/var/lib/xkomhotshot/settings.txt', 'r') as file:
    file = file.readlines()
    token = file[0].rstrip()
    channel = file[1].rstrip()

apiheaders = {
    "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:82.0) Gecko/20100101 Firefox/82.0",
    "X-API-Key": "sJSgnQXySmp6pqNV",
}

apiurl = "https://mobileapi.x-kom.pl/api/v1/xkom/hotShots/current?onlyHeader=false"

def getHotShot():
    r = requests.get(url=apiurl, headers=apiheaders).json()
    return([r['PromotionName'], r['Price'], r['OldPrice'], "https://www.x-kom.pl/goracy_strzal/"+r['Id'], r['Product']['MainPhoto']['Url']])

async def main():
    bot = Bot(token)
    epic = getHotShot()
    description = "Item: {}\nCena: {}PLN\nStara cena: {}PLN\nLink: {}".format(epic[0], epic[1], epic[2], epic[3])
    try:
       await bot.send_photo(chat_id=channel, photo=epic[4], caption=description)
    except:
       await bot.send_message(chat_id=channel, text=description)

if __name__ == '__main__':
   asyncio.run(main())
