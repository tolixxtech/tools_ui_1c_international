//Признак использования настроек
&НаКлиенте
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
&НаКлиенте
Перем мТипыОбрабатываемыхОбъектов Экспорт;

&НаКлиенте
Перем мНастройка;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ИзменитьЗначениеСуммы(Знач ТекущееЗначение)
	//УстановитьЗначение
	Если ВидДействияНадСуммой = 0 Тогда
		Возврат ПараметрДействия;
		
		//Увеличить на сумму
	ИначеЕсли ВидДействияНадСуммой = 1 Тогда
		Возврат ТекущееЗначение + ПараметрДействия;
		
		//Увеличить на %
	ИначеЕсли ВидДействияНадСуммой = 2 Тогда
		Возврат ТекущееЗначение * (100 + ПараметрДействия) / 100;
		
		//Уменьшить на сумму
	ИначеЕсли ВидДействияНадСуммой = 3 Тогда
		Возврат ТекущееЗначение - ПараметрДействия;
		
		//Уменьшить на %
	ИначеЕсли ВидДействияНадСуммой = 4 Тогда
		Возврат ТекущееЗначение * (100 - ПараметрДействия) / 100;
	КонецЕсли;
КонецФункции

// Выполняет обработку объектов.
//
// Параметры:
//  Объект                 - обрабатываемый объект.
//  ПорядковыйНомерОбъекта - порядковый номер обрабатываемого объекта.
//
&НаСервере
Процедура ОбработатьОбъект(Ссылка, ПорядковыйНомерОбъекта, ПараметрыЗаписиОбъектов)

	Объект = Ссылка.ПолучитьОбъект();
	Если ОбрабатыватьТабличныеЧасти Тогда
		СтрокаТЧ=Объект[НайденныеОбъектыТЧ[ПорядковыйНомерОбъекта].Т_ТЧ][НайденныеОбъектыТЧ[ПорядковыйНомерОбъекта].Т_НомерСтроки
			- 1];
	КонецЕсли;

	Для Каждого Реквизит Из Реквизиты Цикл
		Если Реквизит.Реквизит = ТекущийРеквизит Тогда
			Объект[Реквизит.Реквизит] = ИзменитьЗначениеСуммы(Объект[Реквизит.Реквизит]);
		ИначеЕсли Реквизит.Реквизит + "_ТЧ_12345" = ТекущийРеквизит Тогда
			СтрокаТЧ[Реквизит.Реквизит] = ИзменитьЗначениеСуммы(СтрокаТЧ[Реквизит.Реквизит]);
		КонецЕсли;
	КонецЦикла;
	
	
//	Объект.Записать();
	Если UT_Common.ЗаписатьОбъектВБазу(Объект, ПараметрыЗаписиОбъектов) Тогда
		UT_CommonClientServer.СообщитьПользователю(СтрШаблон("Объект %1 УСПЕХ!!!", Объект));
	КонецЕсли;

КонецПроцедуры // ОбработатьОбъект()

// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Функция ВыполнитьОбработку(ПараметрыЗаписиОбъектов) Экспорт

	Индикатор = ПолучитьИндикаторПроцесса(НайденныеОбъекты.Количество());
	Для Индекс = 0 По НайденныеОбъекты.Количество() - 1 Цикл
		ОбработатьИндикатор(Индикатор, Индекс + 1);

		СтрокаНайденныхОбъектов=НайденныеОбъектыТЧ.Получить(Индекс);

		Если СтрокаНайденныхОбъектов.Выбрать Тогда//

			ОбработатьОбъект(СтрокаНайденныхОбъектов.Объект, Индекс, ПараметрыЗаписиОбъектов);
		КонецЕсли;
	КонецЦикла;

	Если Индекс > 0 Тогда
		//ОповеститьОбИзменении(Тип(ОбъектПоиска.Тип + "Ссылка." + ОбъектПоиска.Имя));
	КонецЕсли;

	Возврат Индекс;
КонецФункции // вВыполнитьОбработку()

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура СохранитьНастройку() Экспорт

	Если ПустаяСтрока(ТекущаяНастройкаПредставление) Тогда
		ПоказатьПредупреждение( ,
			"Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;

	НоваяНастройка = Новый Структура;
	НоваяНастройка.Вставить("Обработка", ТекущаяНастройкаПредставление);
	НоваяНастройка.Вставить("Прочее", Новый Структура);

	Для Каждого РеквизитНастройки Из мНастройка Цикл
		Выполнить ("НоваяНастройка.Прочее.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ)
			+ ");");
	КонецЦикла;

	ДоступныеОбработки = ЭтаФорма.ВладелецФормы.ДоступныеОбработки;
	ТекущаяДоступнаяНастройка = Неопределено;
	Для Каждого ТекущаяДоступнаяНастройка Из ДоступныеОбработки.ПолучитьЭлементы() Цикл
		Если ТекущаяДоступнаяНастройка.ПолучитьИдентификатор() = Родитель Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если ТекущаяНастройка = Неопределено Или Не ТекущаяНастройка.Обработка = ТекущаяНастройкаПредставление Тогда
		Если ТекущаяДоступнаяНастройка <> Неопределено Тогда
			НоваяСтрока = ТекущаяДоступнаяНастройка.ПолучитьЭлементы().Добавить();
			НоваяСтрока.Обработка = ТекущаяНастройкаПредставление;
			НоваяСтрока.Настройка.Добавить(НоваяНастройка);

			ЭтаФорма.ВладелецФормы.Элементы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

	Если ТекущаяДоступнаяНастройка <> Неопределено И ТекущаяСтрока > -1 Тогда
		Для Каждого ТекНастройка Из ТекущаяДоступнаяНастройка.ПолучитьЭлементы() Цикл
			Если ТекНастройка.ПолучитьИдентификатор() = ТекущаяСтрока Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;

		Если ТекНастройка.Настройка.Количество() = 0 Тогда
			ТекНастройка.Настройка.Добавить(НоваяНастройка);
		Иначе
			ТекНастройка.Настройка[0].Значение = НоваяНастройка;
		КонецЕсли;
	КонецЕсли;

	ТекущаяНастройка = НоваяНастройка;
	ЭтаФорма.Модифицированность = Ложь;
КонецПроцедуры // вСохранитьНастройку()

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура ЗагрузитьНастройку() Экспорт

	Если Элементы.ТекущаяНастройка.СписокВыбора.Количество() = 0 Тогда
		УстановитьИмяНастройки("Новая настройка");
	Иначе
		Если Не ТекущаяНастройка.Прочее = Неопределено Тогда
			мНастройка = ТекущаяНастройка.Прочее;
		КонецЕсли;
	КонецЕсли;

	Для Каждого РеквизитНастройки Из мНастройка Цикл
		//@skip-warning
		Значение = мНастройка[РеквизитНастройки.Ключ];
		Выполнить (Строка(РеквизитНастройки.Ключ) + " = Значение;");
	КонецЦикла;

КонецПроцедуры //вЗагрузитьНастройку()

// Устанавливает значение реквизита "ТекущаяНастройка" по имени настройки или произвольно.
//
// Параметры:
//  ИмяНастройки   - произвольное имя настройки, которое необходимо установить.
//
&НаКлиенте
Процедура УстановитьИмяНастройки(ИмяНастройки = "") Экспорт

	Если ПустаяСтрока(ИмяНастройки) Тогда
		Если ТекущаяНастройка = Неопределено Тогда
			ТекущаяНастройкаПредставление = "";
		Иначе
			ТекущаяНастройкаПредставление = ТекущаяНастройка.Обработка;
		КонецЕсли;
	Иначе
		ТекущаяНастройкаПредставление = ИмяНастройки;
	КонецЕсли;

КонецПроцедуры // вУстановитьИмяНастройки()

// Получает структуру для индикации прогресса цикла.
//
// Параметры:
//  КоличествоПроходов - Число - максимальное значение счетчика;
//  ПредставлениеПроцесса - Строка, "Выполнено" - отображаемое название процесса;
//  ВнутреннийСчетчик - Булево, *Истина - использовать внутренний счетчик с начальным значением 1,
//                    иначе нужно будет передавать значение счетчика при каждом вызове обновления индикатора;
//  КоличествоОбновлений - Число, *100 - всего количество обновлений индикатора;
//  ЛиВыводитьВремя - Булево, *Истина - выводить приблизительное время до окончания процесса;
//  РазрешитьПрерывание - Булево, *Истина - разрешает пользователю прерывать процесс.
//
// Возвращаемое значение:
//  Структура - которую потом нужно будет передавать в метод ЛксОбработатьИндикатор.
//
&НаКлиенте
Функция ПолучитьИндикаторПроцесса(КоличествоПроходов, ПредставлениеПроцесса = "Выполнено", ВнутреннийСчетчик = Истина,
	КоличествоОбновлений = 100, ЛиВыводитьВремя = Истина, РазрешитьПрерывание = Истина) Экспорт

	Индикатор = Новый Структура;
	Индикатор.Вставить("КоличествоПроходов", КоличествоПроходов);
	Индикатор.Вставить("ДатаНачалаПроцесса", ТекущаяДата());
	Индикатор.Вставить("ПредставлениеПроцесса", ПредставлениеПроцесса);
	Индикатор.Вставить("ЛиВыводитьВремя", ЛиВыводитьВремя);
	Индикатор.Вставить("РазрешитьПрерывание", РазрешитьПрерывание);
	Индикатор.Вставить("ВнутреннийСчетчик", ВнутреннийСчетчик);
	Индикатор.Вставить("Шаг", КоличествоПроходов / КоличествоОбновлений);
	Индикатор.Вставить("СледующийСчетчик", 0);
	Индикатор.Вставить("Счетчик", 0);
	Возврат Индикатор;

КонецФункции // ЛксПолучитьИндикаторПроцесса()

// Проверяет и обновляет индикатор. Нужно вызывать на каждом проходе индицируемого цикла.
//
// Параметры:
//  Индикатор    - Структура - индикатора, полученная методом ЛксПолучитьИндикаторПроцесса;
//  Счетчик      - Число - внешний счетчик цикла, используется при ВнутреннийСчетчик = Ложь.
//
&НаКлиенте
Процедура ОбработатьИндикатор(Индикатор, Счетчик = 0) Экспорт

	Если Индикатор.ВнутреннийСчетчик Тогда
		Индикатор.Счетчик = Индикатор.Счетчик + 1;
		Счетчик = Индикатор.Счетчик;
	КонецЕсли;
	Если Индикатор.РазрешитьПрерывание Тогда
		ОбработкаПрерыванияПользователя();
	КонецЕсли;

	Если Счетчик > Индикатор.СледующийСчетчик Тогда
		Индикатор.СледующийСчетчик = Цел(Счетчик + Индикатор.Шаг);
		Если Индикатор.ЛиВыводитьВремя Тогда
			ПрошлоВремени = ТекущаяДата() - Индикатор.ДатаНачалаПроцесса;
			Осталось = ПрошлоВремени * (Индикатор.КоличествоПроходов / Счетчик - 1);
			Часов = Цел(Осталось / 3600);
			Осталось = Осталось - (Часов * 3600);
			Минут = Цел(Осталось / 60);
			Секунд = Цел(Цел(Осталось - (Минут * 60)));
			ОсталосьВремени = Формат(Часов, "ЧЦ=2; ЧН=00; ЧВН=") + ":" + Формат(Минут, "ЧЦ=2; ЧН=00; ЧВН=") + ":"
				+ Формат(Секунд, "ЧЦ=2; ЧН=00; ЧВН=");
			ТекстОсталось = "Осталось: ~" + ОсталосьВремени;
		Иначе
			ТекстОсталось = "";
		КонецЕсли;

		Если Индикатор.КоличествоПроходов > 0 Тогда
			ТекстСостояния = ТекстОсталось;
		Иначе
			ТекстСостояния = "";
		КонецЕсли;

		Состояние(Индикатор.ПредставлениеПроцесса, Счетчик / Индикатор.КоличествоПроходов * 100, ТекстСостояния);
	КонецЕсли;

	Если Счетчик = Индикатор.КоличествоПроходов Тогда
		Состояние(Индикатор.ПредставлениеПроцесса, 100, ТекстСостояния);
	КонецЕсли;

КонецПроцедуры // ЛксОбработатьИндикатор()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если мИспользоватьНастройки Тогда
		УстановитьИмяНастройки();
		ЗагрузитьНастройку();
	Иначе
		Элементы.ТекущаяНастройка.Доступность = Ложь;
		Элементы.СохранитьНастройки.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Настройка") Тогда
		ТекущаяНастройка = Параметры.Настройка;
	КонецЕсли;
	Если Параметры.Свойство("НайденныеОбъекты") Тогда
		НайденныеОбъекты.ЗагрузитьЗначения(Параметры.НайденныеОбъекты);
	КонецЕсли;

	Если Параметры.Свойство("НайденныеОбъектыТЧ") Тогда

		ТЗНО=Параметры.НайденныеОбъектыТЧ.Выгрузить();

		НайденныеОбъектыТЧ.Загрузить(ТЗНО);
	КонецЕсли;
	ТекущаяСтрока = -1;
	Если Параметры.Свойство("ТекущаяСтрока") Тогда
		Если Параметры.ТекущаяСтрока <> Неопределено Тогда
			ТекущаяСтрока = Параметры.ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Свойство("Родитель") Тогда
		Родитель = Параметры.Родитель;
	КонецЕсли;
	//Если Параметры.Свойство("ОбъектПоиска") Тогда
	//	ОбъектПоиска = Параметры.ОбъектПоиска;
	//КонецЕсли;

	Элементы.ТекущаяНастройка.СписокВыбора.Очистить();
	Если Параметры.Свойство("Настройки") Тогда
		Для Каждого Строка Из Параметры.Настройки Цикл
			Элементы.ТекущаяНастройка.СписокВыбора.Добавить(Строка, Строка.Обработка);
		КонецЦикла;
	КонецЕсли;

	Если Параметры.Свойство("ТаблицаРеквизитов") Тогда
		ТАбРеквизитов=Параметры.ТаблицаРеквизитов;
		ТАбРеквизитов.Сортировать("ЭтоТЧ");
		Для Каждого Реквизит Из Параметры.ТаблицаРеквизитов Цикл
			НоваяСтрока = Реквизиты.Добавить();
			НоваяСтрока.Реквизит      = Реквизит.Имя;//?(ПустаяСтрока(Реквизит.Синоним), Реквизит.Имя, Реквизит.Синоним);
			НоваяСтрока.Идентификатор = Реквизит.Представление;
			НоваяСтрока.Тип           = Реквизит.Тип;
			НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
			НоваяСтрока.РеквизитТЧ	  = Реквизит.ЭтоТЧ;
			Если Реквизит.Тип = ОписаниеТипа("Число") Тогда
				Элементы.ТекущийРеквизит.СписокВыбора.Добавить(Реквизит.Имя + ?(Реквизит.ЭтоТЧ, "_ТЧ_12345", ""),
					Реквизит.Представление + ?(Реквизит.ЭтоТЧ, " [ТЧ]", ""));
			КонецЕсли;
		КонецЦикла;
		Если Элементы.ТекущийРеквизит.СписокВыбора.Количество() > 0 Тогда
			ТекущийРеквизит= Элементы.ТекущийРеквизит.СписокВыбора[0].Значение;
		КонецЕсли;

	КонецЕсли;
	Если Параметры.Свойство("ОбрабатыватьТабличныеЧасти") Тогда
		ОбрабатыватьТабличныеЧасти=Параметры.ОбрабатыватьТабличныеЧасти;
	КонецЕсли;

КонецПроцедуры
&НаСервере
Функция ОписаниеТипа(ТипСтрокой) Экспорт

	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип(ТипСтрокой));
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);

	Возврат ОписаниеТипов;

КонецФункции // вОписаниеТипа()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ВыполнитьОбработкуКоманда(Команда)
	ОбработаноОбъектов = ВыполнитьОбработку(UT_CommonClientServer.ПараметрыЗаписиФормы(
		ЭтотОбъект.ВладелецФормы));

	ПоказатьПредупреждение( , "Обработка <" + СокрЛП(ЭтаФорма.Заголовок) + "> завершена!
																		   |Обработано объектов: " + ОбработаноОбъектов
		+ ".");
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиКоманда(Команда)
	СохранитьНастройку();
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если Не ТекущаяНастройка = ВыбранноеЗначение Тогда

		Если ЭтаФорма.Модифицированность Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("ТекущаяНастройкаОбработкаВыбораЗавершение", ЭтаФорма,
				Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение)), "Сохранить текущую настройку?",
				РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
			Возврат;
		КонецЕсли;

		ТекущаяНастройкаОбработкаВыбораФрагмент(ВыбранноеЗначение);

	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаОбработкаВыбораЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	ВыбранноеЗначение = ДополнительныеПараметры.ВыбранноеЗначение;
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьНастройку();
	КонецЕсли;

	ТекущаяНастройкаОбработкаВыбораФрагмент(ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаОбработкаВыбораФрагмент(Знач ВыбранноеЗначение)

	ТекущаяНастройка = ВыбранноеЗначение;
	УстановитьИмяНастройки();

	ЗагрузитьНастройку();

КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("");

//мНастройка.<Имя реквизита> = <Значение реквизита>;

мТипыОбрабатываемыхОбъектов = "Документ";