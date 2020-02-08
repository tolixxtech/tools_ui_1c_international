&НаСервере
Процедура ЗаполнитьТаблицуКонстант()

	УстановитьПривилегированныйРежим(Истина);

	ТаблицаКонстант.Очистить();

	Для Каждого Константа Из Метаданные.Константы Цикл

		НоваяСтрока = ТаблицаКонстант.Добавить();
		НоваяСтрока.ИмяКонстанты = Константа.Имя;
		НоваяСтрока.СинонимКонстанты = Константа.Синоним;
		НоваяСтрока.ОписаниеТипов = Константа.Тип;
		НоваяСтрока.ЗначениеКонстанты = Константы[Константа.Имя].Получить();
		НоваяСтрока.ЕстьХранилищеЗначения = Константа.Тип.СодержитТип(Тип("ХранилищеЗначения"));

		ТипЗначенияКонстанты = Новый ОписаниеТипов(Константа.Тип, , "ХранилищеЗначения");
		Если ТипЗначенияКонстанты.Типы().Количество() = 0 Тогда
			НоваяСтрока.ТолькоХранилищеЗначений = Истина;
		КонецЕсли;

	КонецЦикла;

	// Заполним функциональные опции констант
	Для Каждого ФОпция Из Метаданные.ФункциональныеОпции Цикл
		Если Не Метаданные.Константы.Содержит(ФОпция.Хранение) Тогда
			Продолжить;
		КонецЕсли;

		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("ИмяКонстанты", ФОпция.Хранение.Имя);

		НайденныеСтроки = ТаблицаКонстант.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;

		НайденныеСтроки[0].ФОпция = ФОпция.Имя;
		НайденныеСтроки[0].ПривилегированныйРежимПриПолучении = ФОпция.ПривилегированныйРежимПриПолучении;
	КонецЦикла;

КонецПроцедуры
&НаСервере
Процедура ВывестиЭлементыКонстантНаФорму()
	МассивДобавляемыхРеквизитов = Новый Массив;

	Для Каждого ТекКонстанта Из ТаблицаКонстант Цикл
		ТипЗначенияКонстанты = ТекКонстанта.ОписаниеТипов;
		Если ТекКонстанта.ЕстьХранилищеЗначения И ТекКонстанта.ТолькоХранилищеЗначений Тогда
			ТипЗначенияКонстанты = Новый ОписаниеТипов("Строка");
		КонецЕсли;

		НовыйРеквизит = Новый РеквизитФормы(ТекКонстанта.ИмяКонстанты, ТипЗначенияКонстанты, "",
			ТекКонстанта.СинонимКонстанты, Истина);
		МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизит);
	КонецЦикла;

	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов, );

	// Теперь выводим на форму контанту с описанием
	ГруппаКонстант = Элементы.ГруппаКонстант;

	Для Каждого ТекКонстанта Из ТаблицаКонстант Цикл
		// Делаем группу под каждую константу, чтобы ее можно было разрисовывать
		ОписаниеГруппы = УИ_РаботаСФормами.НовыйОписаниеГруппыФормы();
		ОписаниеГруппы.Имя = "Группа_" + ТекКонстанта.ИмяКонстанты;
		ОписаниеГруппы.Заголовок = ТекКонстанта.СинонимКонстанты;
		ОписаниеГруппы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ОписаниеГруппы.ОтображатьЗаголовок = Ложь;
		ОписаниеГруппы.Родитель = ГруппаКонстант;

		ГруппаТекущейКонстанты = УИ_РаботаСФормами.СоздатьГруппуПоОписанию(ЭтотОбъект, ОписаниеГруппы);
		ГруппаТекущейКонстанты.СквозноеВыравнивание=СквозноеВыравнивание.Использовать;
		ГруппаТекущейКонстанты.РастягиватьПоГоризонтали	=Истина;
				
		// Декорация заголовка константы
		ОписаниеЭлемента = УИ_РаботаСФормами.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.СоздаватьРеквизит = Ложь;
		ОписаниеЭлемента.СоздаватьЭлемент = Истина;
		ОписаниеЭлемента.Имя = "Заголовок_" + ТекКонстанта.ИмяКонстанты;
		ОписаниеЭлемента.Заголовок=ЗаголовокЭлементаКонстанты(ТекКонстанта.ИмяКонстанты, ТекКонстанта.СинонимКонстанты,
			ПоказыватьСиноним);
		ОписаниеЭлемента.РодительЭлемента = ГруппаТекущейКонстанты;
		ОписаниеЭлемента.Параметры.Тип=Тип("ДекорацияФормы");
		ОписаниеЭлемента.Параметры.Вставить("Вид", ВидДекорацииФормы.Надпись);
		ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоГоризонтали", Истина);

		УИ_РаботаСФормами.СоздатьЭлементПоОписанию(ЭтотОбъект, ОписаниеЭлемента);
		
		
		// поле редактирования константы
		ОписаниеЭлемента = УИ_РаботаСФормами.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.СоздаватьРеквизит = Ложь;
		ОписаниеЭлемента.СоздаватьЭлемент = Истина;
		ОписаниеЭлемента.Имя = ТекКонстанта.ИмяКонстанты;
		ОписаниеЭлемента.ПутьКДанным = ТекКонстанта.ИмяКонстанты;
		ОписаниеЭлемента.Вставить("ПутьКРеквизиту", ТекКонстанта.ИмяКонстанты);
		ОписаниеЭлемента.РодительЭлемента = ГруппаТекущейКонстанты;

		Если (ТекКонстанта.ОписаниеТипов.Типы().Количество() = 1 И ТекКонстанта.ОписаниеТипов.СодержитТип(Тип(
			"Булево"))) Тогда
			ОписаниеЭлемента.Параметры.Вставить("Вид", ВидПоляФормы.ПолеФлажка);
		КонецЕсли;
		Если ТекКонстанта.ЕстьХранилищеЗначения Тогда
			ОписаниеЭлемента.Параметры.Вставить("Доступность", Ложь);
		КонецЕсли;
		ОписаниеЭлемента.Параметры.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
		ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоГоризонтали", Истина);

		ОписаниеЭлемента.Действия.Вставить("ПриИзменении", "КонстантаПриИзменении");

		УИ_РаботаСФормами.СоздатьЭлементПоОписанию(ЭтотОбъект, ОписаниеЭлемента);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПоказыватьСиноним=Истина;

	ЗаполнитьТаблицуКонстант();
	ВывестиЭлементыКонстантНаФорму();
	УстановитьЗначенияКонстантВРеквизитыФормы();

	УИ_РаботаСФормами.ФормаПриСозданииНаСервереСоздатьРеквизитыПараметровЗаписи(ЭтотОбъект,
		Элементы.ГруппаПараметрыЗаписи);
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияКонстантВРеквизитыФормы()
	Для Каждого ТекКонстанта Из ТаблицаКонстант Цикл
		ЭтотОбъект[ТекКонстанта.ИмяКонстанты] = ТекКонстанта.ЗначениеКонстанты;
		Элементы["Группа_" + ТекКонстанта.ИмяКонстанты].ЦветФона = Новый Цвет;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	ВсеУспешно = Истина;
	Для Каждого СтрокаКонстанты Из ТаблицаКонстант Цикл
		Если Не СтрокаКонстанты.Изменено Тогда
			Продолжить;
		КонецЕсли;
		Если СтрокаКонстанты.ЕстьХранилищеЗначения Тогда
			Продолжить;
		КонецЕсли;

		МенеджерКонстанты = Константы[СтрокаКонстанты.ИмяКонстанты].СоздатьМенеджерЗначения();
		МенеджерКонстанты.Прочитать();
		МенеджерКонстанты.Значение = ЭтотОбъект[СтрокаКонстанты.ИмяКонстанты];

		Если УИ_ОбщегоНазначения.ЗаписатьОбъектВБазу(МенеджерКонстанты,
			УИ_ОбщегоНазначенияКлиентСервер.ПараметрыЗаписиФормы(ЭтотОбъект)) Тогда
			СтрокаКонстанты.Изменено = Ложь;

			// Установим цвет измененной константы на группу
			ЭлементГруппа = Элементы["Группа_" + СтрокаКонстанты.ИмяКонстанты];
			ЭлементГруппа.ЦветФона = Новый Цвет;
		Иначе
			ВсеУспешно = Ложь;

		КонецЕсли;

	КонецЦикла;

	Если ВсеУспешно Тогда
		ЭтотОбъект.Модифицированность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрочитатьКонстанты()
	ЗаполнитьТаблицуКонстант();
	УстановитьЗначенияКонстантВРеквизитыФормы();
	Модифицированность = Ложь;
КонецПроцедуры

&НаКлиенте
Функция ЕстьИзмененныеКонстанты()
	ЕстьИзменения = Ложь;
	Для Каждого СтрокаКонстанты Из ТаблицаКонстант Цикл
		Если СтрокаКонстанты.Изменено Тогда
			ЕстьИзменения = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат ЕстьИзменения;
КонецФункции

&НаКлиенте
Процедура Перечитать(Команда)
	Если ЕстьИзмененныеКонстанты() Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПеречитатьЗаверешение", ЭтотОбъект),
			"Есть измененные константы. Произвести запись перед чтением?", РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		ПрочитатьКонстанты();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьЗаверешение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьНаСервере();
	КонецЕсли;

	ПрочитатьКонстанты();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьКонстанты(Команда)
	ЗаписатьНаСервере();
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КонстантаПриИзменении(Элемент)
	ИмяКонстанты = Элемент.Имя;

	// Установим цвет измененной константы на группу
	ЭлементГруппа = Элементы["Группа_" + ИмяКонстанты];
	ЭлементГруппа.ЦветФона = WebЦвета.БледноБирюзовый;

	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ИмяКонстанты", ИмяКонстанты);

	НайденныеСтроки = ТаблицаКонстант.НайтиСтроки(СтруктураПоиска);
	Для Каждого Константа Из НайденныеСтроки Цикл
		Константа.Изменено = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПоискКонстант(СтрокаПоискаПереданная)
	Поиск=СокрЛП(НРег(СтрокаПоискаПереданная));
	Для Каждого ТекСтрокаКонстанты Из ТаблицаКонстант Цикл
		ВидимостьКонстанты=Истина;
		Если ЗначениеЗаполнено(Поиск) Тогда
			ВидимостьКонстанты=СтрНайти(НРег(ТекСтрокаКонстанты.ИмяКонстанты), Поиск) > 0 Или СтрНайти(
				НРег(ТекСтрокаКонстанты.СинонимКонстанты), Поиск) > 0;
		КонецЕсли;

		Элементы["Группа_" + ТекСтрокаКонстанты.ИмяКонстанты].Видимость=ВидимостьКонстанты;
		Элементы["Заголовок_" + ТекСтрокаКонстанты.ИмяКонстанты].Заголовок=ЗаголовокЭлементаКонстанты(
			ТекСтрокаКонстанты.ИмяКонстанты, ТекСтрокаКонстанты.СинонимКонстанты, ПоказыватьСиноним, Поиск);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	СтрокаПоиска=Текст;
	ОбработатьПоискКонстант(Текст);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокЭлементаКонстанты(ИмяКонстанты, СинонимКонстанты, ПоказыватьСиноним, ТекстПоиска = "")
	Заголовок=ИмяКонстанты;
	Если ПоказыватьСиноним Тогда
		Заголовок = Заголовок + ": (" + СинонимКонстанты + ")";
	КонецЕсли;

	Если ЗначениеЗаполнено(ТекстПоиска) Тогда
		ЗаголовокИзначальный=Заголовок;
		ЗаголовокДляПоиска=НРег(ЗаголовокИзначальный);
		НовыйЗаголовок="";
		ДлинаСтрокиПоиска=СтрДлина(ТекстПоиска);

		ПозицияСимвола=СтрНайти(ЗаголовокДляПоиска, ТекстПоиска);
		Пока ПозицияСимвола > 0 Цикл
			ФорматированнаяСтрокаПоиска=Новый ФорматированнаяСтрока(Сред(ЗаголовокИзначальный, ПозицияСимвола,
				ДлинаСтрокиПоиска), Новый Шрифт(, , , Истина), WebЦвета.Красный);
			НовыйЗаголовок=Новый ФорматированнаяСтрока(НовыйЗаголовок, Лев(ЗаголовокИзначальный, ПозицияСимвола - 1),
				ФорматированнаяСтрокаПоиска);

			ЗаголовокИзначальный=Сред(ЗаголовокИзначальный, ПозицияСимвола + ДлинаСтрокиПоиска);
			ЗаголовокДляПоиска=НРег(ЗаголовокИзначальный);

			ПозицияСимвола=СтрНайти(ЗаголовокДляПоиска, ТекстПоиска);

		КонецЦикла;

		Если ЗначениеЗаполнено(НовыйЗаголовок) Тогда
			НовыйЗаголовок=Новый ФорматированнаяСтрока(НовыйЗаголовок, ЗаголовокИзначальный);
			Заголовок=НовыйЗаголовок;
		КонецЕсли;
	КонецЕсли;
	Возврат Заголовок;
КонецФункции
&НаКлиенте
Процедура ПоказыватьСинонимПриИзменении(Элемент)
	Для Каждого ТекКонстанта Из ТаблицаКонстант Цикл
		Элементы["Заголовок_" + ТекКонстанта.ИмяКонстанты].Заголовок=ЗаголовокЭлементаКонстанты(
			ТекКонстанта.ИмяКонстанты, ТекКонстанта.СинонимКонстанты, ПоказыватьСиноним, НРег(СокрЛП(СтрокаПоиска)));
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	ОбработатьПоискКонстант("");
КонецПроцедуры


//@skip-warning
&НаКлиенте
Процедура Подключаемый_НастроитьПараметрыЗаписи(Команда)
	УИ_ОбщегоНазначенияКлиент.РедактироватьПараметрыЗаписи(ЭтотОбъект);
КонецПроцедуры