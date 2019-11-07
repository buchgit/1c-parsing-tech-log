&НаКлиенте
Перем СтарыеКолонки;
&НаКлиенте
Перем СписокИнформационныхБаз;
&НаКлиенте
Перем СписокПроцессов;
&НаКлиенте
Перем СоответсвиеСинонимовСвойств;


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СоответсвиеСинонимовСвойств = ПолучитьСоответсвиеСинонимовСвойств();
	ЗагрузитьНастройки(Неопределено);
	Если НЕ ЗначениеЗаполнено(Список) Тогда
		Список="session";
	КонецЕсли;
	Элементы.Список.СписокВыбора.Добавить("infobase","инф. базы");
	Элементы.Список.СписокВыбора.Добавить("server","сервера");
	Элементы.Список.СписокВыбора.Добавить("process","процессы");
	Элементы.Список.СписокВыбора.Добавить("connection","соединения");
	Элементы.Список.СписокВыбора.Добавить("session","сеансы");
	ПоляТаблицыДанных(Неопределено);
	
	СтарыеКолонки = новый Массив;
	
КонецПроцедуры




&НаКлиенте
Процедура ЗамерПриИзменении(Элемент)
	ЗагрузитьНастройки(Неопределено);
КонецПроцедуры

&НаСервере
Функция ПолучитьСоответсвиеСинонимовСвойств()
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	возврат РеквизитОбъект.ПолучитьСоответсвиеСинонимовСвойств()
КонецФункции

&НаКлиенте
Процедура ЗагрузитьНастройки(Команда)
	Попытка
		мНастройка = УправлениеХранилищемНастроекВызовСервера.ДанныеИзБезопасногоХранилища(Замер);
		Если мНастройка<>Неопределено Тогда
			КодировкаТекстаФайла = мНастройка.КодировкаТекстаФайла;
			ПутьКИсполняемомуФайлуRAC = мНастройка.ПутьКИсполняемомуФайлуRAC;
	
			Корзина.Очистить();
			Для каждого стр из мНастройка.Корзина Цикл
				стр_н = Корзина.Добавить();
				ЗаполнитьЗначенияСвойств(стр_н,стр);
			КонецЦикла;
			
			ТаблицаКластеров.Очистить();
			Для каждого стр из мНастройка.Кластеры Цикл
				стр_н = ТаблицаКластеров.Добавить();
				ЗаполнитьЗначенияСвойств(стр_н,стр);
				стр_н.key = стр_н.server+"("+стр_н.port_ras+") -> "+стр_н.name;
			КонецЦикла;
	
		КонецЕсли;
	Исключение
		Сообщить("Не верные настройки. Выберете данные!");
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокСеансов(Команда)
	ПолучтьСписокНаКлиенте("session");
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКластеровВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	ПолучтьСписокНаКлиенте(Список);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКластеровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПолучтьСписокНаКлиенте(Список);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	ПолучтьСписокНаКлиенте(Список);
КонецПроцедуры



&НаКлиенте
Процедура ПолучитьДанные(Команда)
	ПолучтьСписокНаКлиенте(Список);
КонецПроцедуры

&НаКлиенте
Процедура ПолучтьСписокНаКлиенте(list,licenses=Ложь)
	
	Элементы.ДатаОбновления.ТолькоПросмотр = Истина;
	Элементы.ДатаОбновления.ЦветФона = новый Цвет();
	ТекущиеДанные = Элементы.ТаблицаКластеров.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// сбросим флаг текущий
	Для каждого стр из ТаблицаКластеров Цикл
		стр.current = Ложь;
	КонецЦикла;
	
	ТекущиеДанные.current = Истина;
	
	Если СтарыеКолонки=Неопределено Тогда
		СтарыеКолонки = новый Массив;
	КонецЕсли;	
	
	мПараметры = СформироватьСтруктуруЗапроса(ТекущиеДанные);
	
	ДатаОбновления = ТекущаяДата();

	СтруктураДанныхОтвета = ПолучитьСписок(мПараметры,list,licenses);
	
	Если list="infobase" Тогда
		СписокИнформационныхБаз = СтруктураДанныхОтвета.МассивСоответствиеДанных;
	КонецЕсли;
	
	ДлительностьЗапроса = СтруктураДанныхОтвета.Длительность;
	
	ДобавитьПредставлениеInfobase(СтруктураДанныхОтвета.МассивСоответствиеДанных);
	
	СоздатьИОбновитьКолонки(СтруктураДанныхОтвета.МассивСоответствиеДанных,list);
	
	ВычислитьФункцииАгрегации(СтруктураДанныхОтвета.МассивСоответствиеДанных,list);
	
	ЗаполнитьТаблицуСвойств(СтруктураДанныхОтвета.МассивСоответствиеДанных,list);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоляТаблицыДанных(Команда)
	Элементы.ТаблицаСвойств.Видимость = НЕ Элементы.ТаблицаСвойств.Видимость;
	Элементы.ТаблицаДанныхПоляТаблицыДанных.Пометка = Элементы.ТаблицаДанныхПоляТаблицыДанных.Пометка;  
КонецПроцедуры



&НаСервере
Функция ПолучитьСписок(мПараметры,list,licenses=Ложь)
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	возврат РеквизитОбъект.ПолучитьСписок(мПараметры,list,licenses)
КонецФункции

&НаКлиенте
Функция СформироватьСтруктуруЗапроса(Знач ТекущиеДанные)
	
	мПараметры = новый Структура();
	мПараметры.Вставить("ПутьКИсполняемомуФайлуRAC",ПутьКИсполняемомуФайлуRAC);
	мПараметры.Вставить("КодировкаТекстаФайла",КодировкаТекстаФайла);
	Если НЕ ТекущиеДанные=Неопределено Тогда
		мПараметры.Вставить("server",ТекущиеДанные.server);
		мПараметры.Вставить("port_ras",ТекущиеДанные.port_ras);
		мПараметры.Вставить("cluster",ТекущиеДанные.cluster);
		мПараметры.Вставить("cluster_user",ТекущиеДанные.cluster_user);
		мПараметры.Вставить("cluster_pwd",ТекущиеДанные.cluster_pwd);
		cluster = ТекущиеДанные.cluster;
	Иначе
		мПараметры.Вставить("server","");
		мПараметры.Вставить("port_ras",1545);
		мПараметры.Вставить("cluster","");
		мПараметры.Вставить("cluster_user","");
		мПараметры.Вставить("cluster_pwd","");
		cluster = "";
	КонецЕсли;
	
	Возврат мПараметры;

КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуСвойств(Знач МассивСоответствиеДанных,Знач list)
	
	Перем стр, стр_н;
	
	ТаблицаСвойств.Очистить();
	
	Для каждого стр из МассивСоответствиеДанных Цикл
		Для каждого эл из стр Цикл
			стр_н = ТаблицаСвойств.Добавить();
			стр_н.use = Истина;
			стр_н.name = эл.Ключ;
			стр_н.list = list; 
			стр_н.type = ТипЗнч(эл.Значение); 
			стр_н.synonim = СоответсвиеСинонимовСвойств.Получить(эл.Ключ);
		КонецЦикла;
		Прервать;
	КонецЦикла;
	
	// проставим флажки
	СоответствиеКолонок = новый Соответствие();
	
	Для каждого стр из СтарыеКолонки Цикл
		СоответствиеКолонок.Вставить(стр.Ключ,стр);
	КонецЦикла;
	
	Для каждого стр из ТаблицаСвойств Цикл
		Колонка = СоответствиеКолонок.Получить(стр.name);
		Если Колонка=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		стр.use = Колонка.Видимость;
	КонецЦикла;	
	

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДополнительныеСвойстваВыбранногоЭлементаДанных(Команда)
	//TODO: Вставить содержимое обработчика
КонецПроцедуры


&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для каждого стр из ТаблицаСвойств Цикл
		стр.use = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	Для каждого стр из ТаблицаСвойств Цикл
		стр.use = Истина;
	КонецЦикла;
КонецПроцедуры



&НаСервере
Процедура ВычислитьФункцииАгрегации(Знач МассивСоответствиеДанных,Знач list)
	
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	
	// очистили
	ТаблицаАгрегацииДанных.Очистить();	
	
	МассивСтруктурАгрегацииДанных = РеквизитОбъект.ВычислитьФункцииАгрегации(МассивСоответствиеДанных, Корзина, list);
	
	Для каждого стр из МассивСтруктурАгрегацииДанных Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаАгрегацииДанных.Добавить(),стр);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИОбновитьКолонки(Знач МассивСоответствиеДанных,Знач list)
	
	Перем ИмяКолонки, Колонки, КС, КЧ, МассивТипов, ОписаниеТипов, ОписаниеЧисло, стр, стр_н, ш, элем;
	
	Колонки = новый Массив;
	МассивТипов = новый Массив;
	МассивТипов.Добавить(Тип("Строка"));
	МассивТипов.Добавить(Тип("Число"));
	МассивТипов.Добавить(Тип("Булево"));
	МассивТипов.Добавить(Тип("Дата"));
	КС = Новый КвалификаторыСтроки(200);
	КЧ = Новый КвалификаторыЧисла(20,3);
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов, , ,КЧ, КС);
	ОписаниеЧисло = Новый ОписаниеТипов("Число", , ,КЧ);	
	
	Колонки = новый массив;
	
	Для каждого элем из МассивСоответствиеДанных Цикл	
		
		ш=0;
		Для каждого стр из элем Цикл
			ИмяКолонки = "колонка_"+XMLСтрока(ш);
			Заголовок = стр.Ключ;
			Синоним = СоответсвиеСинонимовСвойств.Получить(Заголовок);
			Если НЕ Синоним=Неопределено Тогда
				Заголовок = Синоним;
			КонецЕсли;
			Колонки.Добавить(новый Структура("Имя,Ключ,ТипСтрокой,ТипЗначения,Ширина,Заголовок,ИмяКолонки,ИмяСледующегоЭлемента,ТолькоПросмотр,Видимость",ИмяКолонки,стр.Ключ,Строка(ТипЗнч(стр.Значение)),ОписаниеТипов,10,Заголовок,ИмяКолонки,Неопределено,Истина,Истина));
			ш=ш+1;
		КонецЦикла;
		прервать;
		
	КонецЦикла;

	ПолучитьНастройкиКолонокТекущегоСписка(Колонки, list);
	
	// создадим динамически таблицу 
	Попытка
		СоздатьДинамическиеКолонкиТаблицы("ТаблицаДанных",Колонки,СтарыеКолонки);
	Исключение
	КонецПопытки;
	
	
	СтарыеКолонки = Колонки;
		
	ТаблицаДанных.Очистить();
	
	Для каждого элем из МассивСоответствиеДанных Цикл
		стр_н = ТаблицаДанных.Добавить();
		ш=0;
		Для каждого стр из элем Цикл
			ИмяКолонки = "колонка_"+XMLСтрока(ш);
			стр_н[ИмяКолонки]=стр.Значение;
			ш=ш+1;
		КонецЦикла;	
	КонецЦикла;

	//Элементы.Декорация1.Видимость = ТаблицаДанных.Количество()=0;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьКолонок(list)
	
	СоответствиеКолонок = новый Соответствие();
	
	Для каждого стр из СтарыеКолонки Цикл
		СоответствиеКолонок.Вставить(стр.Ключ,стр);
	КонецЦикла;
	
	ВидимыхПолей = 0;
	
	Для каждого стр из ТаблицаСвойств Цикл
		
		СвойстваКолонки = СоответствиеКолонок.Получить(стр.name);
		Если СвойстваКолонки=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Элемент = Элементы.Найти("ТаблицаДанных"+СвойстваКолонки.ИмяКолонки);
		
		Если Элемент=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ Элемент.Видимость=стр.use Тогда
			Элемент.Видимость = стр.use;
			СвойстваКолонки.Видимость = стр.use;
		КонецЕсли;
		
		Если Элемент.Видимость=Истина Тогда
			ВидимыхПолей=ВидимыхПолей+1;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВидимыхПолей=0 Тогда
		Сообщить("Вы убрали все поля. Оставьте хотябы одно поле!");
	КонецЕсли;
	
КонецПроцедуры  


&НаКлиенте
Процедура СохранитьНастройкиКолонокТекущегоСписка(Знач list)
	Перем мНастройка;
	Перем Ключ;
	// Сохраним настройки
	Ключ = Строка(ПользователиВызовСервера.ТекущийПользователь())+" МониторRAS1C.ФормаМонитора";
	мНастройка = УправлениеХранилищемНастроекВызовСервера.ДанныеИзБезопасногоХранилища(Замер,Ключ);
	Если мНастройка=Неопределено Тогда
		мНастройка = новый Структура;
		мНастройка.Вставить("ФормаМонитора",новый Соответствие);
	КонецЕсли;
	
	мНастройка.ФормаМонитора.Вставить(list,новый Структура("Колонки",СтарыеКолонки));
	
	УправлениеХранилищемНастроекВызовСервера.ЗаписатьДанныеВБезопасноеХранилищеРасширенный(Замер,мНастройка,"Настройки пользователя формы монитора",Ключ);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНастройкиКолонокТекущегоСписка(Знач Колонки,Знач list)
	
	Перем мНастройка;
	Перем Ключ;
	// Получим настройки
	Ключ = Строка(ПользователиВызовСервера.ТекущийПользователь())+" МониторRAS1C.ФормаМонитора";
	мНастройка = УправлениеХранилищемНастроекВызовСервера.ДанныеИзБезопасногоХранилища(Замер,Ключ);

	Если мНастройка=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Колонки=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиКолонки = мНастройка.ФормаМонитора.Получить(list);
	
	Если НастройкиКолонки=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СоответствиеКолонок = новый Соответствие();
	
	Для каждого стр из Колонки Цикл
		СоответствиеКолонок.Вставить(стр.Ключ,стр);
	КонецЦикла;
	
	Для каждого стр из НастройкиКолонки.Колонки Цикл
		Колонка = СоответствиеКолонок.Получить(стр.Ключ);
		Если Колонка=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Колонка.Видимость = стр.Видимость;
	КонецЦикла;
		
КонецПроцедуры

// Процедура - Создать динамические колонки таблицы
//
// Параметры:
//  ИмяТаблицы					 - строка	 - имя таблицы на форме строкой
//  МассивСтруктурКолонок		 - 	 - описание создаваемых колонок
//  МассивСтруктурТекущихКолонок - 	 - описание текущих колонок для удаления из текущей таблицы
&НаСервере
Процедура СоздатьДинамическиеКолонкиТаблицы(ИмяТаблицы,МассивСтруктурКолонок,МассивСтруктурТекущихКолонок,КромеИменКолонок="")
	
	МассивУдаляемыхЭлементов = новый Массив;
	МассивДобавляемыхЭлементов = новый Массив;
	
	Для каждого Колонка из МассивСтруктурТекущихКолонок Цикл
		Если Найти(КромеИменКолонок,Колонка.Имя) Тогда
			Продолжить;
		КонецЕсли;
		МассивУдаляемыхЭлементов.Добавить(ИмяТаблицы+"."+Колонка.Имя);
		Элементы.Удалить(Элементы[ИмяТаблицы+Колонка.Имя]);    
	КонецЦикла;   
	
	МассивТипов = новый Массив;
	МассивТипов.Добавить(Тип("ТаблицаЗначений"));           
	ОписаниеТиповТаблица = Новый ОписаниеТипов(МассивТипов);
	МассивТипов = новый Массив;
	МассивТипов.Добавить(Тип("Строка"));          
	ОписаниеТиповСтрока = Новый ОписаниеТипов(МассивТипов);
	
	Для каждого Колонка из МассивСтруктурКолонок Цикл
		Если Найти(КромеИменКолонок,Колонка.Имя) Тогда
			Продолжить;
		КонецЕсли;
		Если Колонка.ТипЗначения = ОписаниеТиповТаблица Тогда
			ОписаниеТипов = ОписаниеТиповСтрока;
		Иначе
			ОписаниеТипов = новый ОписаниеТипов(Колонка.ТипЗначения);
		КонецЕсли;
		НовыйРеквизит = Новый РеквизитФормы(Колонка.Имя, ОписаниеТипов, ИмяТаблицы, Колонка.Имя, Ложь);
		МассивДобавляемыхЭлементов.Добавить(НовыйРеквизит);
	КонецЦикла;
	
	Если МассивДобавляемыхЭлементов.Количество()=0 И МассивУдаляемыхЭлементов.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма.ИзменитьРеквизиты(МассивДобавляемыхЭлементов,МассивУдаляемыхЭлементов);
	
	Для каждого Колонка из МассивСтруктурКолонок Цикл                       
		Если Найти(КромеИменКолонок,Колонка.Имя) Тогда
			Продолжить;
		КонецЕсли;
		СледующийЭлемент = Неопределено;
		Если НЕ Колонка.ИмяСледующегоЭлемента=Неопределено Тогда
			СледующийЭлемент = Элементы.Найти(Колонка.ИмяСледующегоЭлемента);
		КонецЕсли;
		НовыйЭлемент = Элементы.Вставить(Элементы[ИмяТаблицы].Имя+Колонка.Имя, Тип("Полеформы"), Элементы[ИмяТаблицы],СледующийЭлемент);
		Если Колонка.ТипСтрокой="Булево" Или  Колонка.ТипСтрокой="Boolean"Тогда
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
		Иначе
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			НовыйЭлемент.Высота = 0;
			НовыйЭлемент.Ширина = Колонка.Ширина;                
		КонецЕсли;
		НовыйЭлемент.Видимость = Колонка.Видимость;
		НовыйЭлемент.Доступность = Истина;
		НовыйЭлемент.ТолькоПросмотр = Колонка.ТолькоПросмотр;   
		НовыйЭлемент.Заголовок = Колонка.Заголовок;
		НовыйЭлемент.Подсказка = Колонка.Заголовок;
		НовыйЭлемент.ПутьКДанным = ИмяТаблицы+"."+Колонка.Имя;    
	КонецЦикла;
	
	
КонецПроцедуры     

&НаКлиенте
Процедура ДобавитьПредставлениеInfobase(Знач МассивСоответствиеДанных)
	
	Перем Соответсвие, стр, эл;
	
	// добавим представление инфобазы
	Если НЕ СписокИнформационныхБаз=Неопределено Тогда
		
		Соответсвие = новый Соответствие;
		Для каждого стр из СписокИнформационныхБаз Цикл
			Соответсвие.Вставить(стр.Получить("infobase"),стр);
		КонецЦикла;
		
		Для каждого стр из МассивСоответствиеДанных Цикл
			эл = Соответсвие.Получить(стр.Получить("infobase"));
			Если Не эл=Неопределено Тогда 
				стр.Вставить("infobase-name",эл.Получить("name"));
			Иначе
				стр.Вставить("infobase-name","");
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры    

&НаСервере
Функция ЗавершитьРаботуСенасаНаСервере(мПараметры)
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	возврат РеквизитОбъект.ЗавершитьСеансПользователя(мПараметры)
КонецФункции

&НаКлиенте
Процедура ЗавершитьРаботуСенаса(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаДанных.ТекущиеДанные;
	ТекущиеДанныеКластеров = Элементы.ТаблицаКластеров.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанныеКластеров=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтарыеКолонки=Неопределено Тогда
		СтарыеКолонки = новый Массив;
	КонецЕсли;		
	
	session = "";
	// найдем поле сессия
	Для каждого стр из СтарыеКолонки Цикл
		Если стр.Ключ="session" Тогда
			session = ТекущиеДанные[стр.Имя];
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если session="" Тогда
		Возврат;
	КонецЕсли;
	
	мПараметры = СформироватьСтруктуруЗапроса(ТекущиеДанныеКластеров);
	мПараметры.Вставить("session",session);
	СтруктураДанныхОтвета = ЗавершитьРаботуСенасаНаСервере(мПараметры);
	
	ДлительностьЗапроса = СтруктураДанныхОтвета.Длительность;	

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьСоставПолей(Команда)
	ОбновитьВидимостьКолонок(Список);
	СохранитьНастройкиКолонокТекущегоСписка(Список);	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастроек(Команда)
	ФормаНастроек = ПолучитьФорму("ВнешняяОбработка.МониторRAS_1C.Форма.ФормаНастроек",Неопределено,ЭтаФорма);
	ФормаНастроек.РежимОткрытияОкна=РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаНастроек.Открыть();
КонецПроцедуры

#Область ИсторияГрафики


&НаКлиенте
Процедура ОбновитьТаблицуДаннымиИзИстории(Направление)
	
	СтруктураДанныхОтвета = ОбновитьТаблицуДаннымиИзИсторииСервер(Замер,ДатаОбновления,Список,Направление);
	
	СоздатьИОбновитьКолонки(СтруктураДанныхОтвета.МассивСоответствиеДанных,Список);
	
	ВычислитьФункцииАгрегации(СтруктураДанныхОтвета.МассивСоответствиеДанных,Список);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДатаСобытияШагНазад(Замер, ДатаСобытия, ТипСобытия, Направление)
	
	Дата = Дата(1,1,1);
	
	Запрос = новый Запрос;
	Если Направление="назад" Тогда
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	СобытияЗамера.ДатаСобытия КАК ДатаСобытия
		|ИЗ
		|	Справочник.СобытияЗамера КАК СобытияЗамера
		|ГДЕ
		|	СобытияЗамера.ДатаСобытия < &ДатаСобытия
		|	И СобытияЗамера.НомерСтрокиФайла = 0
		|	И СобытияЗамера.ТипСобытия.Наименование = &ТипСобытия
		|	И СобытияЗамера.Владелец = &Замер
		|УПОРЯДОЧИТЬ ПО
		|	ДатаСобытия УБЫВ";
	Иначе
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	СобытияЗамера.ДатаСобытия КАК ДатаСобытия
		|ИЗ
		|	Справочник.СобытияЗамера КАК СобытияЗамера
		|ГДЕ
		|	СобытияЗамера.ДатаСобытия > &ДатаСобытия
		|	И СобытияЗамера.НомерСтрокиФайла = 0
		|	И СобытияЗамера.ТипСобытия.Наименование = &ТипСобытия
		|	И СобытияЗамера.Владелец = &Замер
		|УПОРЯДОЧИТЬ ПО
		|	ДатаСобытия Возр";
	КонецЕсли;
	Запрос.УстановитьПараметр("Замер", Замер);
	Запрос.УстановитьПараметр("ДатаСобытия", ДатаСобытия);
	Запрос.УстановитьПараметр("ТипСобытия", ТипСобытия);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Дата = Выборка.ДатаСобытия;
	КонецЕсли;
	
	Возврат Дата;
КонецФункции	

&НаСервереБезКонтекста
Функция ОбновитьТаблицуДаннымиИзИсторииСервер(Замер, ДатаСобытия, ТипСобытия, Направление="назад")

	Если ДатаСобытия=Дата(1,1,1) Тогда
		ДатаСобытия=ТекущаяДата();
	КонецЕсли;
	
	ДатаСобытия = ПолучитьДатаСобытияШагНазад(Замер, ДатаСобытия, ТипСобытия, Направление);
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Т.Значение КАК value,
	|	Т.ЗначениеЧисло КАК value_numeric,
	|	Т.Свойство.Наименование КАК name,
	|	Т.Свойство.Синоним КАК synonim,
	|	Т.Ссылка.НомерСтрокиФайла КАК НомерСтрокиФайла,
	|	Т.Ссылка.ТипСобытия КАК ТипСобытия
	|ИЗ
	|	Справочник.СобытияЗамера.КлючевыеСвойства КАК Т
	|ГДЕ
	|	Т.Ссылка.ДатаСобытия = &ДатаСобытия
	|	И
	|	НЕ Т.Ссылка.НомерСтрокиФайла = 0
	|	И Т.Ссылка.ТипСобытия.Наименование = &ТипСобытия
	|	И Т.Ссылка.Владелец = &Замер
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиФайла Возр,
	|	Т.НомерСтроки УБЫВ
	|ИТОГИ
	|ПО
	|	НомерСтрокиФайла";
	Запрос.УстановитьПараметр("Замер", Замер);
	Запрос.УстановитьПараметр("ДатаСобытия", ДатаСобытия);
	Запрос.УстановитьПараметр("ТипСобытия", ТипСобытия);
	
	ВыборкаНомерСтроки = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	МассивСоответствиеДанных = новый Массив;
	
	Пока ВыборкаНомерСтроки.Следующий() Цикл
		
		Выборка = ВыборкаНомерСтроки.Выбрать();
		СоответствиеДанных = новый Соответствие;
		
		Пока Выборка.Следующий() Цикл
			
			Ключ = ?(ЗначениеЗаполнено(Выборка.synonim),Выборка.synonim,Выборка.name);
			
			Если (Выборка.value="0" И Выборка.value_numeric=0) ИЛИ
			Выборка.value_numeric<>0 Тогда
				СоответствиеДанных.Вставить(Ключ,Выборка.value_numeric);
			Иначе
				СоответствиеДанных.Вставить(Ключ,Выборка.value);
			КонецЕсли;
		
		КонецЦикла;	
		
		МассивСоответствиеДанных.Добавить(СоответствиеДанных);
		
	КонецЦикла;
	
	СтруктураДанныхОтвета = новый Структура();
	СтруктураДанныхОтвета.Вставить("МассивСоответствиеДанных",МассивСоответствиеДанных);
	СтруктураДанныхОтвета.Вставить("Длительность",0);
	СтруктураДанныхОтвета.Вставить("duration",0);
	СтруктураДанныхОтвета.Вставить("ТекстОшибки","");
	
	Возврат СтруктураДанныхОтвета;
	
КонецФункции



&НаКлиенте
Процедура ОбновитьГрафикИстории()
	
	ТекущиеДанные = Элементы.ТаблицаАгрегацииДанных.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Свойство = ТекущиеДанные.name;
	
	ОбновитьГрафикИсторииСервер(Свойство);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьГрафикИсторииСервер(Свойство)
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СобытияЗамераКлючевыеСвойства.Свойство как Свойство,
	|	СобытияЗамераКлючевыеСвойства.ЗначениеЧисло как ЗначениеЧисло,
	|	СобытияЗамераКлючевыеСвойства.Ссылка.ДатаСобытия как ДатаСобытия
	|ИЗ
	|	Справочник.СобытияЗамера.КлючевыеСвойства КАК СобытияЗамераКлючевыеСвойства
	|ГДЕ
	|	СобытияЗамераКлючевыеСвойства.Ссылка = &Ссылка
	|	И СобытияЗамераКлючевыеСвойства.Свойство = &Свойство";
	Запрос.УстановитьПараметр("Замер", Замер);
	Запрос.УстановитьПараметр("Свойство", СправочникиСерверПовтИсп.ПолучитьСвойство(Свойство));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	Элементы.ДатаОбновления.ТолькоПросмотр = Ложь;
	Цвет = новый Цвет(200,255,200);
	Элементы.ДатаОбновления.ЦветФона = Цвет;
	ОбновитьТаблицуДаннымиИзИстории("назад");
КонецПроцедуры

&НаКлиенте
Процедура Вперед(Команда)
	Элементы.ДатаОбновления.ТолькоПросмотр = Ложь;
	Цвет = новый Цвет(200,255,255);
	Элементы.ДатаОбновления.ЦветФона = Цвет;
	ОбновитьТаблицуДаннымиИзИстории("вперед");
КонецПроцедуры

&НаКлиенте
Процедура ДатаОбновленияПриИзменении(Элемент)
	
	ОбновитьТаблицуДаннымиИзИстории("назад");
	
КонецПроцедуры



#КонецОбласти
