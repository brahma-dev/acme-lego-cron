const https = require('https');
const fs = require('fs');

// Fetch the lego DNS page
https.get('https://go-acme.github.io/lego/dns/index.html', (res) => {
  let data = '';
  
  res.on('data', (chunk) => {
    data += chunk;
  });
  
  res.on('end', () => {
    // Extract the table content
    const tableMatch = data.match(/<table[^>]*>[\s\S]*?<\/table>/);
    if (!tableMatch) {
      console.error('No table found in the page');
      process.exit(1);
    }
    
    // Extract all code elements from the table
    const codeMatches = [...tableMatch[0].matchAll(/<code>([^<]+)<\/code>/g)];
    const providers = codeMatches.map(m => m[1]);
    
    if (providers.length === 0) {
      console.error('No providers found in table');
      process.exit(1);
    }

    console.log('Found providers:', providers);

    // Format providers using the split function
    const split = (values, width) => {
      const stack = values.reverse();
      let result = '';
      let line = [];
      
      while (stack.length > 0) {
        const item = '`' + stack.pop() + '`';
        
        if (line.join(',').length + item.length > (width - 1)) {
          result = result + line.join(',') + ',<br/>';
          line = [item];
        } else {
          line.push(item);
        }
      }
      if (line.length) {
        result = result + line.join(',');
      }
      return result;
    };

    const formatted = split(providers, 58);
    console.log('Formatted result:', formatted);
    fs.writeFileSync('providers-list.txt', formatted, 'utf8');
  });
}).on('error', (err) => {
  console.error('Failed to fetch page:', err);
  process.exit(1);
});
