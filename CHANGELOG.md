## Changelog
Todas as mudanças nesse projeto serão documentadas aqui.  
  
### version 1.0
- Primeira versão, funcionando localmente.  

### add workflow to windows build
- Adição de workflow no github para build do windows.  

### add sqlite3 for windows
- Melhor compatibilidade com o windows.  

### updates for softdelete in db
- Mudanças para que o delete from não seja usado.  
- Deletes suavizados para garantir integridade do banco.  
- Adição de um método que reativa produtos deletados anteriormente para evitar sobrecarga.  

### version 1.0.1
- Correções para tratamento de valores nulos ao reativar ou criar um produto no banco