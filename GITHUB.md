# „FireM“ bandymas debesyje be „OpenAI“ kreditų

Šis bandymas paleidžia „Tesseract“ ir „PaddleOCR“ GitHub kompiuteryje. Pakete yra visas boto kodas ir vienas ranka paleidžiamas bandymas. Jis sukuria netikras dienos ir savaitės nuotraukas, palygina du nuskaitymus su žinomais skaičiais ir patikrina, kad trūkstamas rodmuo liktų peržiūrai. Paspaudus „Run workflow“, darbas gali baigtis ir išjungus savo kompiuterį.

## Pirmas paleidimas

1. Išskleisk ZIP į naują aplanką.
2. GitHub sukurk **Private** repozitoriją, pavyzdžiui, **firem-medikai**. Pasirink pridėti README, kad iškart atsirastų pagrindinė šaka.
3. Atidaryk repozitoriją ir spausk **Add file → Upload files**. Iš „FireM-Medikai“ aplanko įkelk jo turinį, įskaitant aplanką **.github**. GitHub puslapyje **.github**, **firem** ir **examples** turi būti tame pačiame lygyje. Įkelk tik naujai išskleisto ZIP turinį. [„GitHub“ failų įkėlimo instrukcija](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository)
4. Išsaugok failus pagrindinėje šakoje. Tada atidaryk **Actions → FireM OCR bandymas → Run workflow**. Kai bandymas baigsis, pasirink jo eilutę ir atsidaryk **Summary**. [Oficialūs paleidimo žingsniai](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/manually-run-a-workflow)

Šiam bandymui nereikia „OpenAI“ API rakto, „Discord“ boto rakto ar „OneDrive“ prisijungimo. Boto prijungimas prie tikro „Discord“, realių ataskaitų grafikas ir bendro Excel pildymas yra atskiri vėlesni žingsniai.

## Išlaidos

„GitHub Free“ privačių projektų „Actions“ vykdymui turi atskirą mėnesio kvotą, kuri nepriklauso nuo tavo „ChatGPT“ plano. Vienam bandymui nustatyta iki 12 min. trukmė. Jei paskyroje įjungti mokėjimai ir nori išvengti papildomų išlaidų, GitHub mokėjimų nustatymuose nustatyk „Actions“ biudžetą ir įjunk **Stop usage when budget limit is reached**. [Nemokamo plano kvota](https://docs.github.com/en/billing/reference/product-usage-included) · [Biudžeto nustatymas](https://docs.github.com/en/billing/how-tos/set-up-budgets)

