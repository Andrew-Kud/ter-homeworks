### Задание 1

3. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную vms_ssh_public_root_key.
- побоялся выкладывать в открытом виде, перевел все чувствительные данные в terraform.tfvars

4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
- "~/.authorized_key.json" - исправил на абсолютный путь.
- variable "cloud_id" и variable "folder_id" - не указаны значения переменных.
- "standart-v4" -> "standard-v3"

6. Ответьте, как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ.
- Прерываемая + 5% ЦП = самая дешёвая ВМ.
Ответ - экономия.


---
---
### Задание 2

---
---
### Задание 3

---
---
### Задание 4

---
---
### Задание 5

---
---
### Задание 6

---
---
### Задание 7
1. Напишите, какой командой можно отобразить второй элемент списка test_list.
```
local.test_list[1]
```
`"staging"`


2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
```
length(local.test_list)
```
`3`


3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
```
local.test_map["admin"]
```
`"John"`


4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.
```
> "John is admin for ${local.test_list[2]} server based on OS ${local.servers[local.test_list[2]].image} with ${local.servers[local.test_list[2]].cpu} vcpu, ${local.servers[local.test_list[2]].ram} ram and ${length(local.servers[local.test_list[2]].disks)} virtual disks"
```
`"John is admin for production server based on OS ubuntu-20-04 with 10 vcpu, 40 ram and 4 virtual disks"`


---
---
### Задание 8

1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars.
- Задача поставлена не явно. в terraform.tfvars у меня и близко нет ничего подобного:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
По этому сделаю задачу, как понял.

`varibales.tf:`
```
variable "test" {
  type = list(map(list(string)))
  default = [
    {
      "dev1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
        "10.0.1.7"
      ]
    },
    {
      "dev2" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
        "10.0.2.29"
      ]
    },
    {
      "prod1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
        "10.0.1.30"
      ]
    }
  ]
}
```

2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.
```
var.test[0]["dev1"][0]
```


---
---