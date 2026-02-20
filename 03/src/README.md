### Задание 1



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



---
---
### Задание 8

Исходник:
[webservers]
%{~ for i in webservers ~}
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"] platform_id=${i["platform_id "]}}
%{~ endfor ~}

Исправлено:
[webservers]
%{~ for i in webservers ~}
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]} platform_id=${i["platform_id"]}
%{~ endfor ~}


---
---
### Задание 9

1. Создай test.tf и заполни его:
```
locals {
  rc_full = [for i in range(1, 100) : format("rc%02d", i)]

  rc_filtered = [
    for i in range(1, 97) :
    format("rc%02d", i)
    if (
      tonumber(substr(format("0%d", i), -1, 1)) != 0 &&
      tonumber(substr(format("0%d", i), -1, 1)) != 7 &&
      tonumber(substr(format("0%d", i), -1, 1)) != 8 &&
      tonumber(substr(format("0%d", i), -1, 1)) != 9
    ) || i == 19
  ]
}
```

2. Инициализируй:
```
terraform init
```

3. Зайди в консоль и протестируй:
```
terraform console
```

от 01 до 99:
```
local.rc_full
```

от 01 до 99 исключая окончания 0,7,8,9 (за исключением 19):
```
local.rc_filtered
```

Проверить длину списка:
1.
```
length(local.rc_full)
```
2.
```
length(local.rc_filtered)
```

---
---
