# -*- coding: utf-8 -*-
"""uXBasic örneği (python_is_gunu_takvimi.uxb) için yardımcı Python modülü.
Yalnız standart kütüphane kullanır; uxpython bu dosyayı modulePath ile bulur."""
import calendar
import datetime


def is_gunu_ekle(baslangic, n, tatiller):
    """ISO tarihe (YYYY-AA-GG) n iş günü ekler; hafta sonları ve verilen tatiller sayılmaz. n eksi olabilir."""
    gun = datetime.date.fromisoformat(baslangic)
    tatil = set(tatiller)
    adim = 1 if n >= 0 else -1
    kalan = abs(n)
    while kalan > 0:
        gun += datetime.timedelta(days=adim)
        if gun.weekday() < 5 and gun.isoformat() not in tatil:
            kalan -= 1
    return gun.isoformat()


def is_gunu_say(bas, bit, tatiller):
    """[bas, bit] aralığındaki (uçlar dahil) iş günü sayısı."""
    gun = datetime.date.fromisoformat(bas)
    son = datetime.date.fromisoformat(bit)
    tatil = set(tatiller)
    sayi = 0
    while gun <= son:
        if gun.weekday() < 5 and gun.isoformat() not in tatil:
            sayi += 1
        gun += datetime.timedelta(days=1)
    return sayi


def ay_ozeti(yil, ay):
    """Bir ayın gün sayısı ve ilk gününün haftanın kaçıncı günü olduğu (0 = pazartesi)."""
    ilk_gun, gun_sayisi = calendar.monthrange(yil, ay)
    return {"yil": yil, "ay": ay, "gun": gun_sayisi, "ilk_haftaici": ilk_gun}
