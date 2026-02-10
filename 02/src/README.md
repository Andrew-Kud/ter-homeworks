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

<img width="2556" height="1440" alt="1" src="https://github.com/user-attachments/assets/358d0e94-8075-4bf4-8728-c0b3249e225e" />


---
---
### Задание 2

---
---
### Задание 3

<img width="2557" height="1438" alt="3-1" src="https://github.com/user-attachments/assets/67722a49-b9ab-44a5-bdd4-616ffee2086b" />

<img width="2560" height="1438" alt="3-2" src="https://github.com/user-attachments/assets/89a691e5-8c9d-4369-9f05-7b949fab3c4f" />


---
---
### Задание 4

<img width="2559" height="1439" alt="4" src="https://github.com/user-attachments/assets/615f6b90-15ba-4cf7-9602-32acb319de8a" />


---
---
### Задание 5

<img width="2560" height="1439" alt="5" src="https://github.com/user-attachments/assets/4e3902dd-c452-4601-bb69-670057cd9f98" />


---
---
### Задание 6

<img width="2559" height="1439" alt="6-1" src="https://github.com/user-attachments/assets/ca754309-5e11-4366-bf67-5d904f832f91" />

<img width="2557" height="1439" alt="6-2" src="https://github.com/user-attachments/assets/be244724-17c2-4c75-acb6-a1e677a359d0" />


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

<img width="1280" height="1434" alt="8" src="https://github.com/user-attachments/assets/4096cf04-2ddc-4b6c-8f10-6657a5ae4f3c" />


---
---
### Задание 9

<img width="2559" height="1440" alt="9" src="https://github.com/user-attachments/assets/5980a1bc-7e50-4eaf-ac8e-2f398382378d" />


---
---
---
