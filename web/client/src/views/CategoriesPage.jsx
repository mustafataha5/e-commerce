import React, { useEffect, useState } from 'react';
import Navbar from '../component/Navbar';
import axios from 'axios';
import { 
  Button, 
  CircularProgress, 
  Typography, 
  Box 
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import { Grid } from 'gridjs-react';
import { html } from 'gridjs'; // Import html function from gridjs
import 'gridjs/dist/theme/mermaid.css'; // Optional theme
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const CategoriesPage = ({ 
    
    user, 
    getUser = () => {},
    setData  }) => {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  const getCategories = async () => {
    try {
      const response = await axios.get('http://localhost:8000/api/categories', { withCredentials: true });
      setCategories(response.data.categories);
      setLoading(false);
    } catch (error) {
      console.error('Error ', error);
      setLoading(false);
    }
  };

  useEffect(() => {
    getUser();
    getCategories();
  }, []);

  const handlAdd = () =>{
    navigate(`/admin/categories/new`);
  }
  const handleEdit = (id,index) => {
   // console.log('Edit category with ID:', id);
   const category = categories[index] ; 
   if (category) {
    console.log(category);
       // Set the initial form data for editing
     setData([category.name_en, category.name_ar]);
     navigate(`/admin/categories/${id}`);
   }
  };

  const handleDelete = async (id,index) => {
   
   // console.log(index+" ========= "+id);
    // Optimistically update the UI
    const previousCategories = categories;
     // Confirm deletion
     const name_en = previousCategories[index].name_en
     const confirmDelete = window.confirm(`Are you sure you want to delete the category "${name_en}"?`);
     if (!confirmDelete) return;
    setCategories(prevCategories => prevCategories.filter(category => category._id !== id));

    try {
        const response = await axios.delete(`http://localhost:8000/api/categories/${id}`, { withCredentials: true });
        console.log("Category deleted:", response.data);
        
        // Show success notification with the deleted category name
        toast.success(`Successfully deleted category "${name_en}"!`);
    } catch (err) {
        console.error("Error deleting category:", err);
        
        // Revert the UI on failure
        setCategories(previousCategories);
        toast.error("Failed to delete category. Please try again.");
    }
};


  // Prepare data for the grid
  const formatDataForGrid = () => {
    return categories.map((category, index) => {
      return [
        index + 1, // Row index starting from 1
        category.name_en, // Assuming your category object has 'name_en'
        category.name_ar, // Assuming your category object has 'name_ar'
        category._id // Keep the ID for reference in actions
      ];
    });
  };

  // Prepare the actions for the grid
  const formatActions = (id,index) => {
    return html(`
      <button style="border: none; background: none; color: blue; cursor: pointer;" onclick="editCategory('${id}','${index}')">
        Edit
      </button>
      <button style="border: none; background: none; color: red; cursor: pointer;" onclick="deleteCategory('${id}','${index}')">
        Delete
      </button>
    `);
  };

  // Attach functions to window to use in HTML strings
  window.editCategory = handleEdit;
  window.deleteCategory = handleDelete;

  return (
    <div>
      <Navbar index={1} />
      {loading ? (
        <Box display="flex" justifyContent="center" alignItems="center" height="60vh">
          <CircularProgress />
        </Box>
      ) : (
        <Box m={5} display="flex" flexDirection="column" alignItems="center">
          <Typography variant="h4" gutterBottom>Categories Table</Typography>
          <Button 
            variant="contained" 
            color="primary" 
            startIcon={<AddIcon />} 
            onClick={handlAdd}
            sx={{ mb: 3 }}
          >
            Add New Category
          </Button>
          <Grid
            data={formatDataForGrid()} // Use the formatted data function
            columns={[
              { name: '#', align: 'center' },
              { name: 'Name (EN)', align: 'center' },
              { name: 'Name (AR)', align: 'center' },
              {
                name: 'Action',
                align: 'center',
                formatter: (cell,row) =>{
                   return  formatActions(cell,row._cells[0].data-1);// Call the function to get the HTML
                } ,
              },
            ]}
            pagination={{ limit: 20 }} // Enable pagination
            search={true}
            sort={true}
            style={{
              table: { border: '1px solid #e0e0e0' },
              th: { backgroundColor: '#f5f5f5', fontWeight: 'bold' },
            }}
          />
        </Box>
      )}
    </div>
  );
};

export default CategoriesPage;
