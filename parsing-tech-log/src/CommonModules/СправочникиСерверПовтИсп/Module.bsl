
Функция ПолучитьСобытие(Знач ИмяСобытия) Экспорт
	Возврат ПолучитьСсылкуСправочникаПоКоду("События", ИмяСобытия, Истина);
КонецФункции

Функция ПолучитьПроцесс(Знач Процесс) Экспорт
	Процесс = НРег(Процесс);
	Возврат ПолучитьСсылкуСправочникаПоКоду("Процессы", Процесс, Истина);
КонецФункции

Функция ПолучитьСвойство(Знач ИмяСвойства) Экспорт
	Если СтрДлина(ИмяСвойства)>100 Тогда
		ИмяСвойства = Прав(ИмяСвойства,СтрДлина(ИмяСвойства)-100);
	КонецЕсли;
	// Символы ПС
	ИмяСвойства = СтрЗаменить(ИмяСвойства,Символы.ПС,"");
	Возврат ПолучитьСсылкуСправочникаПоНаименованию("Свойства", ИмяСвойства, Истина, "Синоним");
КонецФункции

Функция ПолучитьСвойствоПоИмениСинониму(Знач ИмяСвойства, Знач ИмяСиноним) Экспорт
	Если СтрДлина(ИмяСвойства)>100 Тогда
		ИмяСвойства = Прав(ИмяСвойства,СтрДлина(ИмяСвойства)-100);
	КонецЕсли;
	Если СтрДлина(ИмяСиноним)>100 Тогда
		ИмяСиноним = Прав(ИмяСиноним,СтрДлина(ИмяСиноним)-100);
	КонецЕсли;
	// Символы ПС
	ИмяСвойства = СтрЗаменить(ИмяСвойства,Символы.ПС,"");
	ИмяСиноним = СтрЗаменить(ИмяСиноним,Символы.ПС,"");
	Возврат ПолучитьСсылкуСправочникаПоНаименованиюИПоСинониму("Свойства", ИмяСвойства, ИмяСиноним, Истина, "Синоним");
КонецФункции

//общая функция для простых справочников
Функция ПолучитьСсылкуСправочникаПоКоду(ЗНАЧ ИмяСправочника, ЗНАЧ Код, СоздатьЕслиНеНайден = Ложь)
	Если НЕ ЗначениеЗаполнено(Код) Тогда
		Возврат Справочники[ИмяСправочника].ПустаяСсылка();
	КонецЕсли;
	
	Результат = Неопределено;		
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК Т
	|ГДЕ
	|	НЕ Т.ПометкаУдаления
	|	И Т.Код = &Код");
	Запрос.УстановитьПараметр("Код", Код);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Если СоздатьЕслиНеНайден Тогда
			СправочникОбъект = Справочники[ИмяСправочника].СоздатьЭлемент();
			СправочникОбъект.Наименование = Код;
			СправочникОбъект.Код = Код;
			СправочникОбъект.Записать();
			Результат = СправочникОбъект.Ссылка;
		Иначе
			Результат = Справочники[ИмяСправочника].ПустаяСсылка();
		КонецЕсли;
	Иначе
		Результат = РезультатЗапроса.Выгрузить()[0].Ссылка;
	КонецЕсли;
	Возврат Результат;	
КонецФункции

Функция ПолучитьСсылкуСправочникаПоНаименованию(ЗНАЧ ИмяСправочника, ЗНАЧ Наименование, СоздатьЕслиНеНайден = Ложь, ИмяСинонима = "")
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Возврат Справочники[ИмяСправочника].ПустаяСсылка();
	КонецЕсли;
	
	Результат = Неопределено;		
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК Т
	|ГДЕ
	|	НЕ Т.ПометкаУдаления
	|	И Т.Наименование = &Наименование");
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Если ЗначениеЗаполнено(ИмяСинонима) Тогда
		Запрос.Текст = Запрос.Текст + " ИЛИ НЕ Т.ПометкаУдаления И Т."+ИмяСинонима+"=&Наименование";		
	КонецЕсли;
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Если СоздатьЕслиНеНайден Тогда
			СправочникОбъект = Справочники[ИмяСправочника].СоздатьЭлемент();
			СправочникОбъект.Наименование = Наименование;
			СправочникОбъект.Код = Наименование;
			СправочникОбъект.Записать();
			Результат = СправочникОбъект.Ссылка;
		Иначе
			Результат = Справочники[ИмяСправочника].ПустаяСсылка();
		КонецЕсли;
	Иначе
		Результат = РезультатЗапроса.Выгрузить()[0].Ссылка;
	КонецЕсли;
	Возврат Результат;	
КонецФункции

Функция ПолучитьСсылкуСправочникаПоНаименованиюИПоСинониму(ЗНАЧ ИмяСправочника, ЗНАЧ Наименование, Знач Синоним, СоздатьЕслиНеНайден = Ложь, ИмяСинонима = "")
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Возврат Справочники[ИмяСправочника].ПустаяСсылка();
	КонецЕсли;
	
	Результат = Неопределено;		
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка КАК Ссылка,
	|	0 КАК Порядок
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК Т
	|ГДЕ
	|	НЕ Т.ПометкаУдаления
	|	И (Т.Наименование = &Наименование
	|			ИЛИ Т."+ИмяСинонима+" = &Синоним)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка,
	|	1
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК Т
	|ГДЕ
	|	НЕ Т.ПометкаУдаления
	|	И (Т.Наименование = &Синоним
	|			ИЛИ Т."+ИмяСинонима+" = &Наименование)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок");
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.УстановитьПараметр("Синоним", Синоним);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Если СоздатьЕслиНеНайден Тогда
			СправочникОбъект = Справочники[ИмяСправочника].СоздатьЭлемент();
			СправочникОбъект.Наименование = Наименование;
			СправочникОбъект.Код = Наименование;
			СправочникОбъект.Синоним = Синоним;
			СправочникОбъект.Записать();
			Результат = СправочникОбъект.Ссылка;
		Иначе
			Результат = Справочники[ИмяСправочника].ПустаяСсылка();
		КонецЕсли;
	Иначе
		Результат = РезультатЗапроса.Выгрузить()[0].Ссылка;
	КонецЕсли;
	Возврат Результат;	
КонецФункции

Функция РеквизитыСвойства(ЗНАЧ Свойство) Экспорт
	РеквизитыСвойства = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Свойство, "НормализацияЗначения, ТекстФункцииНормализации, МногострочныйРежим, Хешировать, ЧисловойРежим, Синоним, Процент");
	Возврат Новый ФиксированнаяСтруктура(РеквизитыСвойства);
КонецФункции
