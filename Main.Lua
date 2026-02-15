-- DetectorScript (LocalScript di dalam Frame)

local frame = script.Parent
local textBox = frame:FindFirstChild("TextBox")
local detectButton = frame:FindFirstChild("TextButton")
local outputLabel = frame:FindFirstChild("TextLabel")

-- Pastikan semua elemen ditemukan
if not (textBox and detectButton and outputLabel) then
	warn("Elemen GUI tidak lengkap!")
	return
end

-- Variabel penyimpanan data sebelumnya
local lastTarget = nil
local previousData = {}   -- key = full name, value = true

-- Fungsi untuk mendapatkan semua descendant full name dari suatu instance
local function getAllDescendantsFullNames(instance)
	local names = {}
	local function recurse(obj)
		for _, child in ipairs(obj:GetChildren()) do
			local full = child:GetFullName()
			table.insert(names, full)
			recurse(child)
		end
	end
	recurse(instance)
	return names
end

-- Fungsi mendapatkan target dari input user
local function getTargetFromInput(inputText)
	local serviceName = inputText:match("^%s*(.-)%s*$")  -- trim spasi
	if serviceName == "" then
		return workspace   -- default
	end
	
	local success, service = pcall(function()
		return game:GetService(serviceName)
	end)
	
	if success and service then
		return service
	else
		-- Jika tidak valid, kembalikan workspace
		return workspace
	end
end

-- Event klik tombol
detectButton.MouseButton1Click:Connect(function()
	local target = getTargetFromInput(textBox.Text)
	
	-- Cek apakah target berubah (ganti service)
	if lastTarget ~= target then
		-- Reset snapshot dan simpan snapshot pertama untuk target baru
		previousData = {}
		lastTarget = target
		
		local currentNames = getAllDescendantsFullNames(target)
		for _, name in ipairs(currentNames) do
			previousData[name] = true
		end
		
		outputLabel.Text = "🔄 Target berubah menjadi " .. target:GetFullName() .. ".\nSnapshot awal disimpan."
		return
	end
	
	-- Jika target sama, lakukan deteksi perubahan
	local currentNames = getAllDescendantsFullNames(target)
	
	-- Cari instance baru (yang tidak ada di previousData)
	local newInstances = {}
	for _, name in ipairs(currentNames) do
		if not previousData[name] then
			table.insert(newInstances, name)
		end
	end
	
	-- Update snapshot untuk deteksi berikutnya
	previousData = {}
	for _, name in ipairs(currentNames) do
		previousData[name] = true
	end
	
	-- Tampilkan hasil
	if #newInstances > 0 then
		outputLabel.Text = "✅ Instance baru ditemukan:\n" .. table.concat(newInstances, "\n")
	else
		outputLabel.Text = "ℹ️ Tidak ada instance baru."
	end
end)
