const fs = require('fs');
const path = require('path');

const targetDir = 'd:\\folder\\Flutter\\chatbot_app\\assets\\data';

const levelMapping = {
  'advance': 'advanced',
  'advanced': 'advanced',
  'beginner': 'beginner',
  'intermediate': 'intermediate'
};

function walkDir(dir, fileList = []) {
  const files = fs.readdirSync(dir);
  for (const file of files) {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) {
      walkDir(filePath, fileList);
    } else if (file.endsWith('.json')) {
      fileList.push(filePath);
    }
  }
  return fileList;
}

try {
  const allJsonFiles = walkDir(targetDir);
  console.log(`Processing and copying ${allJsonFiles.length} files...\n`);

  let count = 0;

  for (const file of allJsonFiles) {
    const relativePath = path.relative(targetDir, file).replace(/\\/g, '/');
    
    // Ignore flat files already in root to avoid self-copying loops
    if (!relativePath.includes('/')) {
      continue;
    }

    const content = fs.readFileSync(file, 'utf8').trim();
    if (content.length === 0) {
      console.log(`⚠️ Skipping empty file: ${relativePath}`);
      continue;
    }

    let data;
    try {
      data = JSON.parse(content);
    } catch (e) {
      console.log(`❌ Error parsing JSON in ${relativePath}: ${e.message}`);
      continue;
    }

    // Extract details from directory structure
    // Structure format: en/es/beginner_career.json
    const parts = relativePath.split('/');
    if (parts.length < 3) {
      console.log(`⚠️ Skipping non-standard path structure: ${relativePath}`);
      continue;
    }

    const nativeLang = parts[0];   // e.g. en
    const learningLang = parts[1]; // e.g. es or ar
    const fileName = parts[2];     // e.g. beginner_career.json
    
    const fileBase = fileName.replace('.json', '');
    const fileBaseParts = fileBase.split('_');
    if (fileBaseParts.length < 2) {
      console.log(`⚠️ Skipping invalid filename format: ${relativePath}`);
      continue;
    }

    let rawLevel = fileBaseParts[0];
    let rawCategory = fileBaseParts[1];

    if (rawLevel === 'intermediate' && fileBaseParts[2] === 'carrer') {
      // Handle the duplicate/misspelled carrier file
      continue;
    }

    const mappedLevel = levelMapping[rawLevel.toLowerCase()] || rawLevel;
    
    // Standardize metadata level inside JSON to match mappedLevel
    if (data.metadata) {
      if (mappedLevel === 'advanced') {
        data.metadata.level = 'Advanced';
      } else if (mappedLevel === 'beginner') {
        data.metadata.level = 'Beginner';
      } else if (mappedLevel === 'intermediate') {
        data.metadata.level = 'Intermediate';
      }
    }

    // Generate output filename format expected by vocab_provider.dart:
    // ${learningLanguageCode}_${level}_${category}.json
    const outputFileName = `${learningLang.toLowerCase()}_${mappedLevel.toLowerCase()}_${rawCategory.toLowerCase()}.json`;
    const outputPath = path.join(targetDir, outputFileName);

    fs.writeFileSync(outputPath, JSON.stringify(data, null, 4), 'utf8');
    console.log(`✅ Copied & Standardized:\n   From: ${relativePath}\n   To:   ${outputFileName}\n`);
    count++;
  }

  console.log(`\n🎉 Processed and organized ${count} flat asset files in assets/data/ successfully!`);
} catch (e) {
  console.log('Error organizing assets: ' + e.message);
}
