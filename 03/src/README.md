### Задание 1

<img width="1413" height="319" alt="1-1" src="https://github.com/user-attachments/assets/150bda82-ae28-49f2-889f-131fe41ca8c9" />

<img width="679" height="541" alt="1-2" src="https://github.com/user-attachments/assets/3b682997-17e6-46bf-82eb-a4c1de60c070" />

<img width="583" height="464" alt="1-3" src="https://github.com/user-attachments/assets/3bb3b1be-0758-4ad8-a763-6cc4defd4911" />


---
---
### Задание 2



---
---
### Задание 3

<img width="2559" height="1025" alt="3-1" src="https://github.com/user-attachments/assets/1a5ec4fd-3d1e-4bc6-ac57-35b6de6184db" />

<img width="2559" height="1136" alt="3-2" src="https://github.com/user-attachments/assets/f8e1d0e8-839f-4581-aec0-6f2f62f15f08" />


---
---
### Задание 4

<img width="837" height="493" alt="4" src="https://github.com/user-attachments/assets/a6380740-1494-4005-b78e-d10a03e2aef8" />


---
---
### Задание 5

<img width="2557" height="1439" alt="5" src="https://github.com/user-attachments/assets/1d7bb89f-2e35-42bd-b209-398a7fd0fe33" />


---
---
### Задание 6

<img width="2560" height="1439" alt="6-1" src="https://github.com/user-attachments/assets/e6cd45b9-1ffc-4f75-8f67-b1a07c1e0097" />

<img width="2560" height="1437" alt="6-2" src="https://github.com/user-attachments/assets/0b296979-17bc-4592-aaff-c552811f54f0" />


---
---
### Задание 7



---
---
### Задание 8

Исходник:
```
[webservers]
%{~ for i in webservers ~}
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"] platform_id=${i["platform_id "]}}
%{~ endfor ~}
```

Исправлено:
```
[webservers]
%{~ for i in webservers ~}
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]} platform_id=${i["platform_id"]}
%{~ endfor ~}
```
<img width="1109" height="447" alt="8" src="https://github.com/user-attachments/assets/7c3f17b9-f96f-43ae-a587-c41fbec66908" />


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
