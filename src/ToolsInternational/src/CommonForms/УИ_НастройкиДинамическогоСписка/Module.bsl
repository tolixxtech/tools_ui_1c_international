#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ФиксированныеНастройкиОтборВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле = Элементы.ФиксированныеНастройкиОтборПравоеЗначение Тогда
		ПоказатьЗначение(, КомпоновщикНастроек.ФиксированныеНастройки.Отбор.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока).ПравоеЗначение);
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура НастройкиОтборВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле = Элементы.НастройкиОтборПравоеЗначение Тогда
		ПоказатьЗначение(, КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока).ПравоеЗначение);
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ЗначениеЗаполнено("" + Параметры.ФиксированныеНастройки.Отбор) Тогда 
		Представление = "1";
	Иначе
		Представление = "0";
	КонецЕсли;
	Элементы.ФиксированныеНастройки.Заголовок = Элементы.ФиксированныеНастройки.Заголовок + "(" + Представление + ")";
	Если ЗначениеЗаполнено("" + Параметры.Настройки.Отбор) Тогда 
		Представление = "1";
	Иначе
		Представление = "0";
	КонецЕсли;
	Элементы.ОбычныеНастройки.Заголовок = Элементы.ОбычныеНастройки.Заголовок + "(" + Представление + ")";

КонецПроцедуры

#КонецОбласти