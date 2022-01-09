#Область ОписаниеПеременных

&НаКлиенте
Перем мПоследнийUUID;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	UT_CommonClientServer.SetOnFormWriteParameters(ЭтотОбъект, Параметры.ПараметрыЗаписи, "");
	
	UT_CodeEditorServer.ФормаПриСозданииНаСервере(ЭтотОбъект);
	UT_CodeEditorServer.СоздатьЭлементыРедактораКода(ЭтотОбъект, "Редактор", Элементы.ПолеАлгоритмаПередЗаписью);
	
	Если Параметры.Свойство("ТипОбъекта") Тогда
		ТипОбъекта = Параметры.ТипОбъекта;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	UT_CodeEditorClient.FormOnOpen(ЭтотОбъект, Новый ОписаниеОповещения("ПриОткрытииЗавершение",ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	ПроцедураПередЗаписью = UT_CodeEditorClient.ТекстКодаРедактора(ЭтотОбъект, "Редактор");
	Закрыть(UT_CommonClientServer.FormWriteSettings(ЭтотОбъект, ""));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьУникальныйИдентификатор(Команда)
	ТекДанные = Элементы.ДополнительныеСвойства.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДопПараметрыОповещения=Новый Структура;
	ДопПараметрыОповещения.Вставить("ТекущаяСтрока", Элементы.ДополнительныеСвойства.ТекущаяСтрока);

	ПоказатьВводСтроки(Новый ОписаниеОповещения("ОбработатьВводУникальногоИдентификатора", ЭтаФорма,
		ДопПараметрыОповещения), мПоследнийUUID, "Введите уникальный идентификатор", , Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВводУникальногоИдентификатора(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;

	Попытка
		пЗначение = Новый УникальныйИдентификатор(Результат);
		мПоследнийUUID = Результат;
	Исключение
		ПоказатьПредупреждение( , "Значение не может быть преобразовано в Уникальный идентификатор!", 20);
		Возврат;
	КонецПопытки;

	ТекДанные = ДополнительныеПараметры.НайтиПоИдентификатору(ДополнительныеПараметры.ТекущаяСтрока);
	Если ТекДанные <> Неопределено Тогда
		ТекДанные.Значение = пЗначение;
	КонецЕсли;
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПолеРедактораДокументСформирован(Элемент)
	UT_CodeEditorClient.ПолеРедактораHTMLДокументСформирован(ЭтотОбъект, Элемент);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПолеРедактораПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	UT_CodeEditorClient.ПолеРедактораHTMLПриНажатии(ЭтотОбъект, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_РедакторКодаОтложеннаяИнициализацияРедакторов()
	UT_CodeEditorClient.РедакторКодаОтложеннаяИнициализацияРедакторов(ЭтотОбъект);
КонецПроцедуры

//@skip-warning
&НаКлиенте 
Процедура Подключаемый_РедакторКодаЗавершениеИнициализации() Экспорт
	UT_CodeEditorClient.УстановитьТекстРедактора(ЭтотОбъект, "Редактор", ПроцедураПередЗаписью);
	
	ДобавляемыйКонтекст = Новый Структура;
	Если ТипОбъекта <> Новый ОписаниеТипов Тогда
		ДобавляемыйКонтекст.Вставить("Объект", ТипОбъекта.Типы()[0]);
	Иначе
		ДобавляемыйКонтекст.Вставить("Объект");
	КонецЕсли;
	UT_CodeEditorClient.ДобавитьКонтекстРедактораКода(ЭтотОбъект, "Редактор", ДобавляемыйКонтекст);
КонецПроцедуры

#КонецОбласти




