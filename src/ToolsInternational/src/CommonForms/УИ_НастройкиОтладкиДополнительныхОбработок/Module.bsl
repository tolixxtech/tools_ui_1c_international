&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	МассивНовыхРеквизитов=Новый Массив;
	МассивНовыхРеквизитов.Добавить(Новый РеквизитФормы("Пользователь", Новый ОписаниеТипов("СправочникСсылка.Пользователи"), "", "Пользователь", Истина));
	МассивНовыхРеквизитов.Добавить(Новый РеквизитФормы("ДополнительнаяОбработка", Новый ОписаниеТипов("СправочникСсылка.AdditionalReportsAndDataProcessors"), "", "Дополнительная обработка", Истина));
	
	ИзменитьРеквизиты(МассивНовыхРеквизитов,);

	ДополнительнаяОбработка=Параметры.ДополнительнаяОбработка;
	
	ЭтотОбъект.ДополнительнаяОбработка = ДополнительнаяОбработка;

	Вид = УИ_ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДополнительнаяОбработка, "Вид");
	Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Или Вид
		= Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		ЭтоОтчет=Истина;
	КонецЕсли;
	
	
	ОписаниеЭлемента=УИ_РаботаСФормами.НовыйОписаниеРеквизитаЭлемента();
	ОписаниеЭлемента.Имя="Пользователь";
	ОписаниеЭлемента.ПутьКДанным="Пользователь";
	УИ_РаботаСФормами.СоздатьЭлементПоОписанию(ЭтотОбъект, ОписаниеЭлемента);
	
	
	СохраненныеНастройки=УИ_ОбщегоНазначения.НастройкиОтладкиДополнительнойОбработки(ДополнительнаяОбработка);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СохраненныеНастройки);
КонецПроцедуры

&НаСервере
Процедура ПрименитьНаСервере()
	СтруктураНастройки=УИ_ОбщегоНазначения.НовыйСтруктураНастройкиОтладкиДополнительнойОбработки();
	ЗаполнитьЗначенияСвойств(СтруктураНастройки, ЭтотОбъект);
	
	УИ_ОбщегоНазначения.ЗаписатьНастройкиОтладкиДополнительнойОбработки(ЭтотОбъект.ДополнительнаяОбработка, СтруктураНастройки);	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	ПрименитьНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНаСервереНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтруктураОписанияВыбираемогоФайла=УИ_ОбщегоНазначенияКлиент.ПустаяСтруктураОписанияВыбираемогоФайла();
	СтруктураОписанияВыбираемогоФайла.ИмяФайла=ИмяФайлаНаСервере;

	Если ЭтоОтчет Тогда
		УИ_ОбщегоНазначенияКлиент.ДобавитьФорматВОписаниеФайлаСохранения(СтруктураОписанияВыбираемогоФайла,
			"Отчет (*.erf)", "erf");
	Иначе
		УИ_ОбщегоНазначенияКлиент.ДобавитьФорматВОписаниеФайлаСохранения(СтруктураОписанияВыбираемогоФайла,
			"Обработка (*.epf)", "epf");
	КонецЕсли;

	УИ_ОбщегоНазначенияКлиент.ПолеФормыИмяФайлаНачалоВыбора(СтруктураОписанияВыбираемогоФайла, Элемент, ДанныеВыбора,
		СтандартнаяОбработка, РежимДиалогаВыбораФайла.Открытие,
		Новый ОписаниеОповещения("ИмяФайлаНаСервереНачалоВыбораЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНаСервереНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Количество()=0 Тогда
		Возврат;
	КонецЕсли;

	ИмяФайлаНаСервере=Результат[0];
КонецПроцедуры