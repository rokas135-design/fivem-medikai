# FireM medikų ataskaitos

Programa vietoje nuskaito PNG ir JPEG priedų kopijas, parodo OCR kandidatus ir klaidas, registruoja patvirtinimus bei paruošia savaitės, mėnesio ir Excel suvestines. Duomenys, nuotraukos ir auditas lieka tavo kompiuteryje. Python, SQLite ir vietinis OCR neturi paslaugos mokesčio ar apdorojimo kvotos.

Pakete yra sintetinės nuotraukos. GTA nuotraukos, darbaknygė, darbuotojų sąrašas ir prisijungimo duomenys į paketą neįtraukti. FiveM profilis išbandytas su dienos statistikos langu dviem raiškomis ir mediko „Darbai“ kortele. Sezono paso atpažinimas skirtas atskirti priedą nuo savaitės ataskaitos. Sezono lygį ir žymas prižiūri komanda. Jei vaizdas neatitinka atpažįstamo išdėstymo, jis lieka peržiūrai.

Pirmam bandymui debesyje su sintetinėmis nuotraukomis naudok [„GitHub Actions“ žingsnius](GITHUB.md).

## Diegimas Windows

Išarchyvuok ZIP į vietinį aplanką ir atidaryk jame PowerShell. Reikia Python 3.11 ar naujesnio. Pradiniam bibliotekų diegimui reikia interneto arba vietinių Python paketų kopijų.

~~~powershell
py -3 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
Copy-Item settings.example.json settings.json
.\.venv\Scripts\python.exe -m unittest discover -s tests -v
~~~

Tikroms nuotraukoms nustatymuose numatytas Tesseract su lietuvių ir anglų kalbų modeliais. Įdiek Tesseract, įsitikink, kad komanda tesseract --list-langs rodo lit ir eng. Jei programa nerandama, nustatyme ocr.executable įrašyk pilną kelią iki tesseract.exe. [Tesseract diegimas ir kalbos](https://tesseract-ocr.github.io/tessdoc/Installation.html)

Alternatyva Windows 10 arba 11 yra ocr.engine = windows su kompiuteryje įdiegtu Windows OCR kalbos paketu, pavyzdžiui, ocr.windows_language = en-US. Šiame režime visi skaičiai turi būti įvesti ranka, sutikrinus juos su vaizdu. Windows OCR neturi patikimumo įverčio. Jei kompiuterio politika riboja PowerShell failų vykdymą, naudok Tesseract.

## Paleisk botą

Po diegimo dukart spustelėk Isbandyti-bota.cmd. Botas perskaitys imituotas mėnesio ir medikų forumo temas, apdoros paketui pridėtas sintetines nuotraukas ir atidarys jų peržiūrą naršyklėje. Demonstracijos duomenys saugomi demo-bot-data. Paskutinio boto ciklo suvestinė yra latest-run.json.

Kai nori apdoroti savo vietines kopijas, dukart spustelėk Paleisti-bota.cmd. Botas perskaitys data/inbox aplanke esančius manifestus ir atidarys peržiūrą. Abu paleidimo failai veikia be Discord boto rakto.

~~~powershell
.\.venv\Scripts\python.exe -m firem bot --demo
.\.venv\Scripts\python.exe -m firem bot
~~~

## Bandymas su pridėtais pavyzdžiais

Pavyzdys naudoja angliškas etiketes ir Windows OCR. Jei turi Tesseract, gali pakeisti examples/settings.json lauką ocr.engine į tesseract, o ocr.language palikti eng. Pavyzdžių duomenų bazė atskirta nuo tikrosios.

~~~powershell
$python = '.\.venv\Scripts\python.exe'
& $python -m firem --config examples/settings.json --data demo-data ingest examples/manifest.json
& $python -m firem --config examples/settings.json --data demo-data review demo-bad
& $python -m firem --config examples/settings.json --data demo-data journal --issues
& $python -m firem --config examples/settings.json --data demo-data approve demo-daily --reviewer 'Tavo vardas' --values examples/verified-daily.json --reason 'Sutikrinta su sintetine nuotrauka'
& $python -m firem --config examples/settings.json --data demo-data daily 2026-11
& $python -m firem --config examples/settings.json --data demo-data weekly 2026-11-02 --at '2026-11-03T00:15:00+02:00'
~~~

Pavyzdyje yra aiški dienos nuotrauka, vaizdas su neįskaitomu skaičiumi, identiška kopija, finalas ir gautas, bet nepasiekiamas priedas. Pavyzdžio rankinio įvedimo failai tinka tik sintetinėms nuotraukoms.

## Nustatymai ir kasdienis naudojimas

- Pakeisk pavyzdinį medikų sąrašą settings.json faile. Įrašyk žaidimo ir Discord vardą. Papildomi laukai from ir until nurodo aktyvumo datas imtinai. Discord paskyros ID galima nurodyti kaip papildomą tapatybės patikrą.
- Kiekvienam mėnesiui nurodyk atskirą months įrašą su opens ir due. Su replace_weekly = true finalo terminas pakeičia to laikotarpio pirmadienio terminą. Pavyzdyje lapkričio 29 d. galioja vietoje lapkričio 30 d. pirmadienio. Datos yra pavyzdinės.
- Sukurk manifestą pagal examples/manifest.json. Kiekvienam priedui reikia unikalaus id, tikslaus kanalo pavadinimo, autoriaus, posted_at laiko su UTC poslinkiu ir santykinio file kelio iki nuotraukos. Priedui be failo gali nurodyti problem. Vietiniai manifestai ir nuotraukų kopijos gali būti tame pačiame aplanke arba jo poaplankyje.
- Dienos rodmenys priskiriami statistikos lange rodomai datai. Programa patikrina, ar ji yra ankstesnė kalendorinė diena pagal įkėlimo laiką Vilniuje ir ar priklauso forum_month temai. Senesnę dieną ar OCR neperskaitytą datą patvirtink per --stat-date ir --reason. Jei naudoji Windows OCR, datą patvirtink ranka, nebent ji jau sutikrinta manifesto stat_date lauke. Mėnesio sandūroje lapkričio 1 d. įkeltas spalio 31 d. rodmuo priklauso spalio temai.
- Vienas patvirtintas dienos įrašas taikomas visai komandai. Savaitės duomenims numatytas antradienio 00:00–pirmadienio 23:59:59,999 langas Vilniaus laiku. Pavėluotai pateiktai ataskaitai nurodyk ankstesnį pirmadienį lauke weekly_due, kitaip ji priskiriama artimiausiam pirmadieniui.
- Finalui galima nurodyti final_month (YYYY-MM). Kai finalas pakeičia savaitės terminą, to laikotarpio „Darbai“ nuotrauka iš nustatyto finalo lango rodoma ir kaip finalo kandidatė. Patvirtink ją atskirai su --slot final. Savaitės ataskaitai galima naudoti tą patį priedą. Jei priskyrimą reikia patikslinti, nurodyk final_month manifeste.
- Numatytasis ocr.profile = firem tikrina konkrečias FiveM ekrano sritis, pavadinimus ir datą arba mediko vardą. Windows OCR skaičių parodo kaip kandidatą tik jei sutampa bent du vaizdo apdorojimo variantai. Kiekvieną kandidatą vis tiek sutikrink ranka. Senasis bendras OCR profilis naudojamas, kai ocr.profile praleistas. Tada galima keisti ocr.aliases, ocr.crop ir ocr.psm.
- Anoniminiai iškvietimai imami iš „Pagelbėta sužeistiems NPC“ dienos statistikoje ir „Pagydytų sužeistų asmenų“ mediko kortelėje. Šio susiejimo nustatymas yra anonymous_calls_source = npc. Kitų iškvietimų rodmenys neįtraukiami.
- Savaitinės nuotraukos autorius, jo forum_medic tema ir žaidimo kortelės vardas turi sutapti. Tarpas žaidimo kortelėje atitinka pabraukimą temos varde. OCR klaidingai perskaitytą žaidimo vardą galima patikslinti per --game-name ir --reason.

~~~powershell
& $python -m firem ingest 'inbox-kopijos\manifest.json'
& $python -m firem review 'PRIEDO-ID'
& $python -m firem approve 'PRIEDO-ID' --reviewer 'Tavo vardas'
& $python -m firem journal --issues
~~~

Per review matysi OCR eilutes, atpažintus skaičius, klaidas ir asset kelią po data. Atidaryk nuotraukos kopiją ir patikrink visus laukus prieš approve. Jei skaičiai neaiškūs arba reikia pataisos, perduok rankiniu būdu sutikrintą JSON failą su visais šešiais rodmenimis per --values ir parašyk --reason. Jei duomenų vaizde įskaityti negali, palik ataskaitą peržiūrai arba naudok reject su priežastimi.

Pakartotinai importuoti ID ir identiškos nuotraukos nepadidina suvestinės. Kai tai pačiai dienai arba to paties mediko laikotarpiui pateikiamos skirtingos nuotraukos, patvirtinant antrąją reikia aiškiai nurodyti ankstesnį ID per --replace ir pateikti priežastį. Neįskaitomas arba nepasiekiamas priedas rodomas kaip gautas įrašas, kurį reikia tikrinti. Būsena „nerasta vietinėje kopijoje“ apibūdina tik turimą medžiagą. Priminimų tekste nėra sankcijų ar oficialių įspėjimų.

## Peržiūra naršyklėje

Rodmenis tikrina jūsų paskirtas ataskaitų tvarkytojas. Po diegimo dukart spustelėk Paleisti-perziura.cmd kompiuteryje, kuriame programa importuoja nuotraukas. Atsidarys vietinis langas su peržiūros eile, nuotrauka, jos data arba mediko vardu ir šešiais laukais. Numatytasis adresas yra http://127.0.0.1:8765. Jei reikia, atidaryk jį ranka.

1. Pasirink ataskaitą. Paspaudus nuotrauką atsidaro visas vaizdas.
2. Sutikrink šešis rodmenis, datą arba mediko vardą. Nepatikimai nuskaityti skaičiai palikti tušti. Jei skaičiaus pačioje nuotraukoje įskaityti nepavyksta, palik ataskaitą peržiūrai, kol gausi aiškesnę kopiją.
3. Įrašyk savo vardą, pažymėk, kad sutikrinai duomenis, ir spausk „Patvirtinti rodmenis“. Žurnale bus įrašytas peržiūrėtojas ir patvirtinti rodmenys.

Peržiūros langas pasiekiamas tik iš to paties kompiuterio. Patvirtinimas įtraukia rodmenis į vietines suvestines. Excel įrašymas ir Discord ✅ turi atskirus patvirtinimo žingsnius. Sezono paso ataskaitos lieka rankinei komandos tvarkai.

~~~powershell
& $python -m firem review-ui --open
# Pavyzdžiams naudok tą pačią duomenų bazę, į kurią juos importavai
& $python -m firem --config examples/settings.json --data demo-data review-ui --open
~~~

## Dviejų OCR palyginimas

Komanda ocr-compare išbando nuotraukos kopiją su dviem vietiniais atpažinimo įrankiais. „Tesseract“ tikrina maketą, laukų etiketes, datą arba mediko vardą ir rodmenis. „PaddleOCR“ atskirai tikrina maketą, datą arba vardą bei tuos pačius šešis skaičius. Rezultatas abu_nuskaitymai_sutampa pasirodo tik tada, kai sutampa visi šeši rodmenys ir abi tapatybės patikros. Ši komanda skirta matavimui. Ji veikia su vietinėmis kopijomis, nekuria patvirtinimo įrašų ir nesijungia prie Discord ar OneDrive.

Šiam papildomam bandymui naudok Python 3.12 arba 3.13 ir „Tesseract“ su lit bei eng kalbomis. Jei tesseract komanda neprieinama, settings.json faile įrašyk pilną kelią į ocr.executable.

~~~powershell
py -3.12 -m venv .venv-ocr
.\.venv-ocr\Scripts\python.exe -m pip install -r requirements.txt -r requirements-ocr-compare.txt
$ocrModel = 'models\latin_PP-OCRv5_mobile_rec'
$ocrSource = 'https://huggingface.co/PaddlePaddle/latin_PP-OCRv5_mobile_rec/resolve/ab2cd5cc5fa6309be2e5acdfe66eca2c2c127d57'
New-Item -ItemType Directory -Force -Path $ocrModel | Out-Null
foreach ($file in @('inference.json', 'inference.pdiparams', 'inference.yml')) {
    curl.exe --location --fail --silent --show-error --output (Join-Path $ocrModel $file) "$ocrSource/$file"
    if ($LASTEXITCODE) { throw "Nepavyko atsisiųsti $file" }
}
~~~

Į settings.json skiltį ocr pridėk lauką "paddle_model_dir": "models/latin_PP-OCRv5_mobile_rec". Palik profile = firem ir anonymous_calls_source = npc. Palyginimui pateik dienos ir savaitės vaizdus atskirai. [Oficialus vietinis modelis](https://huggingface.co/PaddlePaddle/latin_PP-OCRv5_mobile_rec/tree/ab2cd5cc5fa6309be2e5acdfe66eca2c2c127d57)

~~~powershell
.\.venv-ocr\Scripts\python.exe -m firem ocr-compare daily 'C:\kopijos\dienos.png'
.\.venv-ocr\Scripts\python.exe -m firem ocr-compare weekly 'C:\kopijos\savaites.png'
~~~

Patikimumą vertink su naujomis nuotraukomis, kurių nenaudojai iškarpų derinimui. Svarbūs du skaičiai – kiek ataskaitų abu įrankiai perskaitė pilnai ir kiek iš jų sutampa su tikrais rodmenimis. Boto įprastas įrašymas tebėra atskiras nuo bandymo.

## Grafikas

Komanda bot arba tick iš data/inbox paima vietinius manifestus. Į šakninį inbox aplanką dėk *.json, o į atskirus jo poaplankius dėk manifest.json ir priedų kopijas. Naujausias vietinis rezultatas lieka data/latest-run.json.

~~~powershell
& $python -m firem tick
powershell.exe -NoProfile -File .\schedule.ps1 -Register
~~~

Registruojamas vietinis Windows Task Scheduler darbas. Kol kompiuteris gali jį vykdyti, jis kas 15 minučių patikrina laiką. Su --scheduled importas vyksta tik nustatytomis dienomis ir valandomis. Savaitės patikros prasideda pirmadienį 22:00 ir antradienį nuo 00:15. Mėnesio patikra vyksta finalo dieną nuo 22:00 ir kitą dieną nuo 00:15. D–3 ir D–1 dienomis nuo nustatytos valandos paruošiami savaitės ir mėnesio priminimų juodraščiai. Numatytasis laikas 18:00 Europe/Vilnius. Praleistų dienų juodraščių atkurti nereikia, o istorines suvestines galima iškviesti ranka. Windows užduotį galima išjungti Task Scheduler lange.

~~~powershell
& $python -m firem drafts
& $python -m firem approve-draft 'JUODRASCIO-ID' --reviewer 'Tavo vardas'
~~~

Patvirtintas priminimo juodraštis lieka vietoje. Jei nori paskelbti pranešimą, nukopijuok patvirtintą tekstą ranka. Laiką --at bandymams naudok su atskiru --data aplanku.

## Mėnesio uždarymas ir Excel

Pirmą mėnesį įvesk patikrintus kiekvieno aktyvaus mediko pradžios rodmenis. Pavyzdžiui, iš jau peržiūrėtų „Medikų statistika“ lapo B–G langelių. Peržiūrėk patvirtintus finalus, konfliktus ir sumažėjusius rodmenis. Po termino archyvuojamas tik tas planas, kurio digest sutampa su peržiūrėtu. Tik parengti archyvuoti pabaigos rodmenys perkeliami į kito mėnesio pradžią. Naudojant --allow-incomplete būtina užrašyti išimties priežastį. Neparengtiems įrašams rodmenys nepildomi nuliais.

~~~powershell
& $python -m firem baseline 2026-11 'Vardas_Pavarde' 'pradzia.json' --reviewer 'Tavo vardas' --reason 'Sutikrinta su pradžios rodmenimis'
& $python -m firem month 2026-11
& $python -m firem close-month 2026-11 --digest 'PERZIURETAS-DIGEST' --reviewer 'Tavo vardas' --reason 'Patikrinau finalo nuotraukas'
& $python -m firem archive 2026-11
& $python -m firem excel-plan 2026-11 'C:\kelias\iki\vietines-kopijos.xlsx'
~~~

Excel planas atidaro vietinę kopiją skaitymui. Jis patikrina lapų antraštes, mėnesio žymą B3, dienų numeraciją ir skirtumo formules ties mediko eilute. Dienos duomenims parengia B–H laukus „Mėnesio ataskaita“ lape. Archyvuotiems medikų rodmenims parengia B–M laukus „Medikų statistika“ lape. Skirtumus, taškus ir reitingą skaičiuoja esamos Excel formulės. Skirtingos esamos reikšmės žymimos peržiūrai. Mediko vardas turi sutapti su viena esama eilute. Planas pateikia darbaknygės SHA-256 ir esamų bei siūlomų reikšmių poras. Dėl skirtingos paskutinių dviejų rodiklių tvarkos abu lapai susieti atskirai.

### Saugus įrašymas į vietinę kopiją ir varnelės patikra

Pirmiausia pasiimk digest iš excel-plan. Excel-apply sukuria naują failą data/exports aplanke, o kiekvieną atnaujintą eilutę patikrina dar kartą atidaręs išsaugotą kopiją. Jei dienos eilutėje jau yra kita reikšmė, ją praleidžia ir įrašo į peržiūros planą. Dienai skirti visi šeši rodmenys ir „Taip“ įrašomi kartu. Užbaigtai dienos eilutei check-preview parodo ✅. Reakcija Discord taikoma žinutei, todėl jeigu žinutėje yra keli priedai, kiekvienam turi būti patikrinta atitinkama Excel eilutė.

~~~powershell
& $python -m firem excel-apply 2026-11 'C:\kelias\iki\vietines-kopijos.xlsx' --scope daily --digest 'PERZIURETAS-DIGEST' --output 'lapkritis-atnaujinta.xlsx' --reviewer 'Tavo vardas'
& $python -m firem check-preview 2026-11 'data\exports\lapkritis-atnaujinta.xlsx'
~~~

Su --scope final į naują kopiją įrašomi archyvuoti kumuliatyvūs rodmenys. Medikų statistikoje mėnesio pabaigos anoniminiai iškvietimai rašomi į L, pažymos į M. Kai pabaigos reikšmės jau sutikrintos su archyvu, --scope rollover sukuria dar vieną kopiją, perkelia H–M į B–G ir nustato H–M į nulį. Šis žingsnis apima tik „Medikų statistika“ lapą. N–S formulės išlieka. Kol pabaigos rodmenys nuliniai, Excel gali rodyti neigiamus tarpinius skirtumus. Kito mėnesio dienos lapą paruošk atskirai.

Asmeniniam OneDrive pakanka bendrinti vieną darbaknygę per Bendrinti → Nuorodos nustatymai → Bet kas, turintis nuorodą → Gali peržiūrėti → Taikyti → Kopijuoti nuorodą. Tokį failą gali atverti ir žmogus be prisijungimo. Pasirink peržiūros teises prieš kopijuodamas nuorodą. [Microsoft bendrinimo instrukcija](https://support.microsoft.com/en-us/onedrive/share-files-and-folders-in-microsoft-onedrive)

Peržiūros nuoroda suteikia prieigą skaitytojams. Savininkas gali perkelti peržiūrėtus pakeitimus iš naujos vietinės kopijos į bendrinamą darbaknygę. Pagal Microsoft dokumentaciją Excel REST API skirta verslo saugykloms, o asmeninės OneDrive darbaknygės nepalaikomos. [Microsoft Excel API palaikymas](https://learn.microsoft.com/en-us/graph/api/resources/excel?view=graph-rest-1.0)

## Discord priedų skaitymas ateityje

Dabar naudok vietines kopijas. Atskirą discord-fetch komandą galima jungti tik po serverio savininko leidimo. Jai reikia įjungto discord.enabled, nurodytų serverio ir dviejų forumų ID, aplinkos reikšmės FIREM_DISCORD_READ=AUTHORIZED, boto rakto aplinkos kintamajame FIREM_DISCORD_BOT_TOKEN ir aiškios --enable-discord-read vėliavėlės. Laiko langas perduodamas per --since ir --until. Lauke daily_threads susiek YYYY-MM su to mėnesio temos ID, o weekly_threads susiek mediko vardą su jo temos ID. Pavadinimams su papildomais simboliais naudok tikslų forum_names tekstą. Programa patikrina serverį, forumą ir temos pavadinimą. Istoriniam importui gali aiškiai pasirinkti --statistics-month. Atsisiųstos kopijos patenka į vietinį inbox. Pagrindinis grafikas dirba su vietiniais failais.

Gavęs serverio savininko leidimą ir užregistravęs botą Discord Developer Portal, gali naudoti bot --enable-discord-read. Vienas paleidimas atsisiunčia priedus, vietoje juos iškart perduoda OCR ir atnaujina peržiūros eilę. Numatytas 10 dienų atsigręžimo laikotarpis. Jei intervalas kerta mėnesio pradžią, nustatymuose nurodyk ir ankstesnio mėnesio forumo temą. Rankiniam istoriniam patikrinimui gali naudoti --since ir --until. Boto raktą laikyk tik užduotį vykdančio proceso aplinkoje. [Oficialus Discord programos registravimo vadovas](https://github.com/discord/discord-api-docs/blob/main/developers/quick-start/getting-started.mdx)

Tik po atskiro leidimo gali naudoti schedule.ps1 -Register -EnableDiscordRead. Su šiuo pasirinkimu darbo aplinkos kintamieji turi būti prieinami pačiai Windows užduočiai, nes ji vyksta atskirame procese. Kiekvienam grafiko laikui botui užtenka vieno sėkmingo nuskaitymo. Nepavykęs atsisiuntimas lieka klaidų žurnale ir gali būti pakartotas. Vietinis grafikas be šio pasirinkimo dirba su data/inbox.

Skaitymui būsimo serverio savininkas turės patvirtinti View Channel ir Read Message History tik dviem kanalams. Programos nustatymuose turi būti prieinamas Message Content, nes kitaip API gali grąžinti tuščius priedų laukus. Discord žinutėje po vieną žymą į eilutę galima pridėti data=2026-11-01, savaite=2026-11-02 arba finalas=2026-11. Savaitės ir finalo žymos gali būti kartu. Stabilius Discord ID verta susieti su patikrintais žaidimo vardais, jei serverio slapyvardžio žinučių istorija negrąžina. [Discord žinučių dokumentacija](https://github.com/discord/discord-api-docs/blob/main/developers/resources/message.mdx)

### Varnelės siuntimas po atskiro leidimo

Vietinei kopijai pakanka check-preview. Ateityje, po serverio savininko leidimo, discord-check gali uždėti vieną ✅ tik patikrintai žinutei. Tam reikia visų skaitymo leidimų, discord.check_reaction_enabled = true, aplinkos reikšmės FIREM_DISCORD_CHECK=AUTHORIZED ir nustatyme reaction_workbook įrašyto bendros, vietoje sinchronizuojamos Excel darbaknygės kelio. Komanda reikalauja --message-id, --reviewer, check-preview digest ir --confirm-synced-excel. Pastarąjį naudok tik patikrinęs, kad darbaknygė sinchronizuota. Prieš siųsdama komanda sutikrina žinutę ir visus priedų ID. Reakcijai taikomos Discord žinutės istorijos ir reakcijų teisės. [Discord žinučių ir reakcijų dokumentacija](https://github.com/discord/discord-api-docs/blob/main/developers/resources/message.mdx)

Testai Discord duomenis imituoja vietoje. Jie tikrina forumų temas, mėnesio sandūrą, priedų puslapiavimą, tapatybę, neaiškų OCR, sezono paso atskyrimą, ankstesnį finalo terminą, dublikatų kontrolę, Excel įrašymą, kito mėnesio rodmenų perkėlimą ir reakcijos sąlygas.

