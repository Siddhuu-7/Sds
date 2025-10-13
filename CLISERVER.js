const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
   if(req.url==="/tcp"){
    const filePath=path.join(__dirname,"desktop-CLi.zip")
    res.writeHead(200, {
    'Content-Type': 'application/octet-stream',
    'Content-Disposition': 'attachment; filename="sds.zip"'
  });
    const filestream=fs.createReadStream(filePath)
    
    filestream.pipe(res)
    filestream.on("error",(err)=>{
      res.writeHead(200,{"content-type":"text/plain"})
      res.end(err.message)
    })
  }else{
    const filePath=path.join(__dirname,".bat")
    res.writeHead(200, {
    'Content-Type': 'application/octet-stream',
    'Content-Disposition': 'attachment; filename="sds.bat"'
  });
    const filestream=fs.createReadStream(filePath)
    
    filestream.pipe(res)
    filestream.on("error",(err)=>{
      res.writeHead(200,{"content-type":"text/plain"})
      res.end(err.message)
    })
  }
});

server.listen(3000, () => {
  console.log('Server is running on port 3000');
});
