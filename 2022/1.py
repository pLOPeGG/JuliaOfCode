nums = [[]]
while True:
    try:
        v = input()
    except:
        break
    if v == "":
        nums.append([])
    else:
        nums[-1].append(int(v))

print(max(map(sum, nums)))
print(sum(sorted(map(sum, nums))[-3:]))